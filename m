Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0DPXRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 19:17:06 -0400
Received: from n15.bullet.mail.mud.yahoo.com ([68.142.206.42]:42826 "HELO
	n15.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932738Ab0DPXRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 19:17:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 475489.12444.bm@omp105.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=VdYGTPKMQd2oIFR/6p05puvN9QvT5KZEjs0KCdJcludveIu6nigfOhe+Bnb97J3J7rQNG+EJ8qGxS92T03qme6KcYqvt8mXgVDntHoTGoCRIQy3LrNb0a+OBBEDfCzrsSOv1wT9kUenR4+lqzQygwtP7lqbVhLl8mkTocIP2aSc=;
Message-ID: <368225.78206.qm@web111904.mail.gq1.yahoo.com>
X-YMail-OSG: JyaoTvUVM1lNuBSgpLN0qFh9FSCbRnx2u.fOwO9hkMfM.7a
 uxCcPDN7K_QqvoiTBYeMHgiWH2eZbDVkCXBx7cVSFljzvjAnfPkTKrRrZNoN
 LKeLSIseevQ_7QlnbZoeikC_meNRi0P7bZ0E4mrtcYA26cI7zH3FhTykUPpF
 ZGgkFTCCzIjNPTGCjN2cluLwNPcU0YUnHabNH9x1JeVguLvWkfmQMkdwWtNz
 rUmfpEcWTmNWygzOHbQSkBWdRtYhdv0uuRRNVnTcChZr3q7rrJZPwOsCvOhX
 aLMz8oTZRzV8s
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.100.260964
Date: Fri, 16 Apr 2010 16:17:02 -0700 (PDT)
From: Chetan Loke <generationgnu@yahoo.com>
Subject: RE: Memory policy question for NUMA arch....
To: rick.sherm@yahoo.com, andi@firstfloor.org, generationgnu@yahoo.com
Cc: linux-numa@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <243351.5510.qm@web111910.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

PS - Please 'CC' me on the emails.I have not subscribed to the list.

> Hi Andy,
> 
> --- On Wed, 4/7/10, Andi Kleen <andi@firstfloor.org>
> wrote:
> > On Tue, Apr 06, 2010 at 01:46:44PM -0700, Rick Sherm
> wrote:
> > > On a NUMA host, if a driver calls
> __get_free_pages()
> > then
> > > it will eventually invoke
> > ->alloc_pages_current(..). The comment
> > > above/within alloc_pages_current() says
> > 'current->mempolicy' will be
> > > used.So what memory policy will kick-in if the
> driver
> > is trying to
> > > allocate some memory blocks during driver load
> > time(say from probe_one)? System-wide default
> > policy,correct?
> >
> > Actually the policy of the modprobe or the kernel boot
> up
> > if built in
> > (which is interleaving)
> >

I may be wrong but I think there's a difference. system-wide run-time default policy is M_PREFERRED | M_LOCAL and not Interleaving.

So, if current->mempolicy is set then default_policy will not be used. 
And now if you don't want the default_policy mode then what?
I'm stuck in this confused state too. So we have two cases to take care off - 

Case1) current->mempolicy is initialized and so we can just set it to whatever we like and then reset it once we are done with __get_free_pages(..) etc.

Case2) current->mempolicy is not initialized. Then default_policy is used. Now if we have to muck with the default_policy then we will need to lock it down. Otherwise some other consumer will get affected by it.

But both the above solutions are twisted.Why not just create a different wrapper? This way we can leave both current & default_policy alone.

#ifdef CONFIG_NUMA
__get_free_policy_pages(policy,mask,order)??
endif

For now I may end up hacking my kernel and implementing the above mentioned quick and dirty solution. But if there's a cleaner approach then please let me know.

PS - We should create some wrapper's that will automatically figure out the MSIX-affinity(if present/set) and then default the allocation to that node? Also, is there a way to configure irqbalance and ask it to leave these guys alone? Like a config file that says - leave these irqs/pci-devices alone.For now I've shut down irqbalance.

> 
> > -Andi
> >
> 
> Thanks
> Rick
> 

thanks
Chetan Loke


      

