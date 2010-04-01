Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0DANJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:09:48 -0400
Received: from lo.gmane.org ([80.91.229.12]:53735 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab0DANJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:09:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: i915 lockup / extreme delay
Date: Thu, 01 Apr 2010 09:09:24 -0400
Message-ID: <4BB49B04.2000303@myrealbox.com>
References: <ho2jal$oqs$1@dough.gmane.org> <87wrx5m1h3.fsf@pollan.anholt.net>	 <bad735c81003220111y44bfb828vfd4c9fbbcabf3419@mail.gmail.com>	 <87634oid4y.fsf@pollan.anholt.net> <bad735c81003270254i5e1cdb3dv26c1566e5d005e9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
In-Reply-To: <bad735c81003270254i5e1cdb3dv26c1566e5d005e9f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Vogel wrote:
> On Mon, Mar 22, 2010 at 4:34 PM, Eric Anholt <eric@anholt.net> wrote:
>> On Mon, 22 Mar 2010 09:11:06 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
>>> On Mon, Mar 22, 2010 at 5:20 AM, Eric Anholt <eric@anholt.net> wrote:
>>>> On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
>>>>> The 'effect' is that only the mouse pointer works in the X server. The
>>>>> cpu usage on the laptop during the sluggishness is minimal. When I
>>>>> suspend the game with winedbg, the X server slowly becomes responsive again.
>>>>>
>>>>> The output from latencytop seems to point to i915 being the culprit:
>>>> If there's some code doing glFlush()es, it's probably that code at
>>>> fault.  You don't need to do that unless you're doing frontbuffer
>>>> rendering, and if you're doing frontbuffer rendering you should really
>>>> be doing backbuffer rendering.  I don't see a kernel issue here.
>>> That doesnt explain why the box completely locks up on 2.6.34-rc2
>>> though, where only a cold reboot works.
>> Missed that part of the message.  If there's a regression, bisect
>> please.
> 
> Apparently the crash was caused by a hardware bug in the intel chipset
> which is 8086:2a40 rev 07. While doing the bisect I got an error:
> 
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [00:02.0] fault addr dd69a000
> DMAR:[fault reason 05] PTE Write access is not set
> 
> After some googling around, I found this bugzilla entry which explains it:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=538163#c58
> 
> The issue appears that the graphics chip is corrupting memory:
> 
> "Unfortunately, this particular chipset sometimes reads from the GTT, does the
> translation, then writes the translated address back to the _original_ GTT
> instead of to the shadow GTT. That's why you're seeing real physical addresses
> where you should have 'virtual DMA addresses', and you get the faults.   "
> 
> Adding "intel_iommu=igfx_off" to the kernel command line resolved the issue.
> The fedora kernel automatically disables this when it detects this particular
> chipset revision.
> 
> As for the freeze/slowdown right after booting, sysprof shows that more than 77%
> of the time is spent inside: drm_mode_getconnector

http://lists.freedesktop.org/archives/intel-gfx/2010-February/005922.html

I'm waiting for the encoder/connector stuff to get merged before I 
either pester people about that bug again or try to fix it myself.

You can try the same hack I use (comment out the initialization of all 
digital outputs) if you don't use them -- that completely fixes it for me.

--Andy

