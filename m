Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761074Ab2DKTxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2DKTxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:42 -0400
Message-ID: <4F85E133.4030404@redhat.com>
Date: Wed, 11 Apr 2012 16:53:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com> <201204112147.55348.remi@remlab.net>
In-Reply-To: <201204112147.55348.remi@remlab.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-04-2012 15:47, Rémi Denis-Courmont escreveu:
> 	Hello,
> 
> Le mercredi 11 avril 2012 20:02:00 Mauro Carvalho Chehab, vous avez écrit :
>> Using unsigned instead of enum is not a good idea, from API POV, as
>> unsigned has different sizes on 32 bits and 64 bits.
> 
> Fair enough. But then we can do that instead:
> typedef XXX __enum_t;
> where XXX is the unsigned integer with the right number of bits. Since Linux 
> does not use short enums, this ought to work fine.
> 
>> Yet, using enum was really a very bad idea, and, on all new stuff,
>> we're not accepting any new enum field.
> 
> That is unfortunately not true. You do follow that rule for new fields to 
> existing V4L2 structure.

Yes, that's what I meant.

> But you have been royally ignoring that rule when it 
> comes to extending existing enumerations:

The existing enumerations can be extended, by adding new values for unused
values, otherwise API functionality can't be extended. Yet, except
for a gcc bug (or weird optimize option), I fail to see why this would break 
the ABI. 

If this is all about some gcc optimization with newer gcc versions, then maybe
the solution may be to add some pragmas at the code to disable such optimization
when compiling the structs with enum's at videodev2.h.

> linux-media does regularly add new enum values to existing enums. That is new 
> stuff too, and every single time you do that, you do BREAK THE USERSPACE ABI. 
> This is entirely unacceptable and against established kernel development 
> policies.
> 
> For instance, in Linux 3.1, V4L2_CTRL_TYPE_BITMASK was added. This broke 
> userspace.

The patch is:

commit fa4d7096d1fb7c012ebaacefee132007a21e0965
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Mon May 23 04:07:05 2011 -0300

    [media] v4l2-ctrls: add new bitmask control type
    
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
...
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f002006..148d1a5 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1040,6 +1040,7 @@ enum v4l2_ctrl_type {
        V4L2_CTRL_TYPE_INTEGER64     = 5,
        V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
        V4L2_CTRL_TYPE_STRING        = 7,
+ V4L2_CTRL_TYPE_BITMASK       = 8,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */

This doesn't change the existing v4l2_ctrl_type codes. So, it shouldn't be
producing any harm at the existing code.

> And there are some pending patches adding more of the same thing... 
> And V4L2_MEMORY_DMABUF will similarly break the user-to-kernel interface, 
> which is yet worse.
> 
>> That's said, a patch like that were proposed in the past. See:
>> 	http://www.spinics.net/lists/vfl/msg25686.html
>>
>> Alan said there [1] that:
>> 	"Its a fundamental change to a public structure from enum to u32. I think
>> you are right but this change seems too late by several years."
> 
> I cannot see how the kernel is protected against userspace injecting error 
> values into enums. For all I know, depending how the kernel is compiled, 
> userspace might be able to trigger "undefined" behavior in kernel space.
> 
> Is it be several years too late to fix a bug?

No, but causing an ABI breakage like what it would happen by replacing
"enums" by u32 would break all binaries on x86_64 kernels (and vice-versa
if using u64, breaking all i386 binaries). 

>From what I remember from the 2006 discussions, even using "unsigned" may 
lead into breakages on some non-x86 architectures that use u16 for enums,
as, on those archs, unsigned is 32 bits.

> 
> (...)
>> I don't think anything has changed since then that would make it easier
>> to apply a change like that.
> 
> OK. But then you cannot update extend existing enums... No DMA buffers, no 
> integer menu controls...
> 

Regards,
Mauro
