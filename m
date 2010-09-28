Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0I1NzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0I1NzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:55:03 -0400
Date: Tue, 28 Sep 2010 09:54:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace
 e820_/_early string with memblock_"
Message-ID: <20100928135449.GA8950@redhat.com>
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <4CA11918.7050708@kernel.org>
 <4CA11FB7.2080101@zytor.com>
 <4CA126BE.7000609@kernel.org>
 <4CA1283C.9010105@zytor.com>
 <4CA12976.5060504@kernel.org>
 <4CA129EB.5000309@zytor.com>
 <4CA12BAB.1040308@kernel.org>
 <20100928005358.GA6456@redhat.com>
 <4CA16522.8060107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA16522.8060107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:46:42PM -0700, H. Peter Anvin wrote:
> On 09/27/2010 05:53 PM, Vivek Goyal wrote:
> > 
> > Actually, hardcoding the upper limit to 4G is probably not the best idea.
> > Kexec loads the the relocatable binary (purgatory) and I remember that
> > one of the generated relocation type was signed 32 bit and allowed max value
> > to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.
> > 
> > I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
> > so that we search bottom up and not rely on a specific upper limit.
> > 
> 
> No, it's just another crappy hack which is broken in the same way.  It's
> better than open-coding, but it's still a hack.
> 
> The Right Thing[TM] to do is for kexec to communicate the topmost
> address it wants to this code, so it has both the upper and the lower
> boundaries available to it instead of just one.
> 

Being able to specify the upper limit would be the best thing so that
kernel does not have to make any assumptions or hardcode anything.

Question is how to determine the upper limit.

- The upper limit will depend on what is being loaded in reserved region.
  Reserving memory using crashkernel= is a boot time optin and that point
  of time kexec has not even run. So we don't know what is the upper
  limit.

  Now we can do extra reboot to make it happen. Boot first kernel without
  reserving any memory. Introduce an option in kexec which tells user what
  are the segments kexec would like to load (for a given binary) and what
  are there upper memory limits and then user goes ahead modifies the
  command line and reboots the kernel back.

  This all sounds not so clean. Especially upper limit might change based
  on binary being loaded and a user might have to perform a reboot again.

So to me trying to get lowest memory available possible for crashkernel
reservations is not that a bad idea. It is certainly better than making
hardcoded assumptions about the upper limit.

Thanks
Vivek
