Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1EKQOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:14:51 -0400
Received: from mail.tpi.com ([70.99.223.143]:1163 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab1EKQOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:14:47 -0400
Message-ID: <4DCA9899.6070403@canonical.com>
Date: Wed, 11 May 2011 16:09:29 +0200
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org,
        Andy Whitcroft <andy.whitcroft@canonical.com>
Subject: Re: [PATCH V3] fbcon -- fix race between open and removal of framebuffers
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>	<4DC94314.8050701@canonical.com> <20110510234424.5a5b7a08@neptune.home>
In-Reply-To: <20110510234424.5a5b7a08@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 11:44 PM, Bruno Prémont wrote:
> On Tue, 10 May 2011 Tim Gardner<tim.gardner@canonical.com>  wrote:
>>  From ca3ef33e2235c88856a6257c0be63192ab56c678 Mon Sep 17 00:00:00 2001
>> From: Andy Whitcroft<apw@canonical.com>
>> Date: Thu, 29 Jul 2010 16:48:20 +0100
>> Subject: [PATCH] fbcon -- fix race between open and removal of framebuffers
>>
>> Currently there is no locking for updates to the registered_fb list.
>> This allows an open through /dev/fbN to pick up a registered framebuffer
>> pointer in parallel with it being released, as happens when a conflicting
>> framebuffer is ejected or on module unload.  There is also no reference
>> counting on the framebuffer descriptor which is referenced from all open
>> files, leading to references to released or reused memory to persist on
>> these open files.
>>
>> This patch adds a reference count to the framebuffer descriptor to prevent
>> it from being released until after all pending opens are closed.  This
>> allows the pending opens to detect the closed status and unmap themselves.
>> It also adds locking to the framebuffer lookup path, locking it against
>> the removal path such that it is possible to atomically lookup and take a
>> reference to the descriptor.  It also adds locking to the read and write
>> paths which currently could access the framebuffer descriptor after it
>> has been freed.  Finally it moves the device to FBINFO_STATE_REMOVED to
>> indicate that all access should be errored for this device.
>
> What framebuffer drivers was this patch tested with? Just x86 with
> mainstream GPU (intel/amd/nvidia KMS) in compination with vgafb/vesafb or
> did it see some testing with other framebuffers like those from embedded
> world?
>

This patch is also in all of the armel (OMAP3/OMAP4) kernels.

> Otherwise a much smaller (memory leaking) patch would be to just change
> vesafb/vgafb to not free their fb_info after unregistration as was suggested
> by Alan Cox.
>

Sure, I suppose thats possible, but this is the patch that I have working.

<snip>

>
> This only partially protects the list and count as two concurrent
> framebuffer registrations do still race against each other.
> For the issue addressed by this patch I don't think it makes sense to
> have this spinlock at all as it's only used in get_framebuffer_info()
> and in put_framebuffer_info() and put_framebuffer_info() doesn't even
> look at registered_fb or num_registered_fb.
> Such a spinlock makes sense in a separate patch that really protects
> all access to registered_fb or num_registered_fb, be it during framebuffer
> (un)registration or during access from fbcon.
>

Our goal was merely to stop the user space open/close races. I agree 
that the framebuffer registration list needs more orthogonal protection, 
but that is going to be a much larger patch.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
