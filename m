Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0IOSh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:37:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39969 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0IOSh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:37:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
	<20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
	<20100915135016.C9F1.A69D9226@jp.fujitsu.com>
	<1284531262.27089.15725.camel@nimitz>
Date: Wed, 15 Sep 2010 11:37:18 -0700
In-Reply-To: <1284531262.27089.15725.camel@nimitz> (Dave Hansen's message of
	"Tue, 14 Sep 2010 23:14:22 -0700")
Message-ID: <m1d3se7t0h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Hansen <dave@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave@linux.vnet.ibm.com> writes:

> On Wed, 2010-09-15 at 13:53 +0900, KOSAKI Motohiro wrote:
>> > >  ==============================================================
>> > >  
>> > > diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
>> > > --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-14 15:44:29.000000000 -0700
>> > > +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-14 15:58:31.000000000 -0700
>> > > @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
>> > >  {
>> > >  	proc_dointvec_minmax(table, write, buffer, length, ppos);
>> > >  	if (write) {
>> > > +		WARN_ONCE(1, "kernel caches forcefully dropped, "
>> > > +			     "see Documentation/sysctl/vm.txt\n");
>> > 
>> > Documentation updeta seems good but showing warning seems to be meddling to me.
>> 
>> Agreed.
>> 
>> If the motivation is blog's bogus rumor, this is no effective. I easily
>> imazine they will write "Hey, drop_caches may output strange message, 
>> but please ignore it!".
>
> Fair enough.  But, is there a point that we _should_ be warning?  If
> someone is doing this every minute, or every hour, something is pretty
> broken.  Should we at least be doing a WARN_ON() so that the TAINT_WARN
> is set?
>
> I'm worried that there are users out there experiencing real problems
> that aren't reporting it because "workarounds" like this just paper over
> the issue.

For what it is worth.  I had a friend ask me about a system that had 50%
of it's memory consumed by slab caches.  20GB out of 40GB.  The kernel
was suse? 2.6.27 so it's old, but if you are curious.
/proc/sys/vm/drop_caches does nothing in that case.

Thinking about it drop_caches is sufficiently limited I don't see
drop_caches being even to mask problems so Dave I think your basic
concern is overrated.

As for your documentation update your wording change seems to me to be
more obtuse, and in a scolding tone.  If you want people not to use
this facility you should educate people not scold them.

Perhaps something like:

Calling /proc/sys/vm/drop_caches pessimizes system performance.  The
pages freed by writing to drop_caches are easily repurposed when the
need arises, but the kernel instead of wasting those pages by leaving
them holding nothing, instead uses those pages to increase the size
of the filesystem cache.  The larger filesystem cache increases
the likely hood any filesystem access will get a cache hit and will not
need to read from disk.

Eric
