Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423Ab2DLOze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965169Ab2DLOzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:55:32 -0400
Message-ID: <4F86ECD0.6060708@redhat.com>
Date: Thu, 12 Apr 2012 11:55:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl()
 structs
References: <1333648371-24812-1-git-send-email-remi@remlab.net> <4F85B908.4070404@redhat.com> <201204112147.55348.remi@remlab.net> <CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com>
In-Reply-To: <CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-04-2012 05:04, James Courtier-Dutton escreveu:
> 2012/4/11 Rémi Denis-Courmont <remi@remlab.net>:
>>        Hello,
>>
>> Le mercredi 11 avril 2012 20:02:00 Mauro Carvalho Chehab, vous avez écrit :
>>> Using unsigned instead of enum is not a good idea, from API POV, as
>>> unsigned has different sizes on 32 bits and 64 bits.
>>
>> Fair enough. But then we can do that instead:
>> typedef XXX __enum_t;
>> where XXX is the unsigned integer with the right number of bits. Since Linux
>> does not use short enums, this ought to work fine.
>>
>>> Yet, using enum was really a very bad idea, and, on all new stuff,
>>> we're not accepting any new enum field.
>>
>> That is unfortunately not true. You do follow that rule for new fields to
>> existing V4L2 structure. But you have been royally ignoring that rule when it
>> comes to extending existing enumerations:
>>
>> linux-media does regularly add new enum values to existing enums. That is new
>> stuff too, and every single time you do that, you do BREAK THE USERSPACE ABI.
>> This is entirely unacceptable and against established kernel development
>> policies.
>>
>> For instance, in Linux 3.1, V4L2_CTRL_TYPE_BITMASK was added. This broke
>> userspace. And there are some pending patches adding more of the same thing...
>> And V4L2_MEMORY_DMABUF will similarly break the user-to-kernel interface,
>> which is yet worse.
>>
> 
> I agree that breaking user-to-kernel interface is not advised.
> We came across a similar problem some years ago with the ALSA sound
> kernel drivers.
> The solution we used was:
> 1) If a change is likely to change the user-to-kernel API, add a new
> IOCTL for it.
> Then old userland software can use the old IOCTL, and new userland
> software can use the new IOCTL.

V4L2 API has about 80 ioctl's. Add compat code for most of them (as most have
enum's) is not fun.

Also, the issue is not that trivial. Just to give you one example:

struct v4l2_pix_format {
        __u32                   width;
       	__u32                   height;
        __u32                   pixelformat;
        enum v4l2_field         field;
        __u32                   bytesperline;   /* for padding, zero if unused */
        __u32                   sizeimage;
        enum v4l2_colorspace    colorspace;
       	__u32                   priv;           /* private data, depends on pixelformat */
};


This struct has 2 enums, and it is used by a couple structs, like this one:

struct v4l2_framebuffer {
        __u32                   capability;
       	__u32                   flags;
        void                    *base;
       	struct v4l2_pix_format  fmt;
};

This struct is used by a couple ioctls:

#define VIDIOC_G_FBUF            _IOR('V', 10, struct v4l2_framebuffer)
#define VIDIOC_S_FBUF            _IOW('V', 11, struct v4l2_framebuffer)

The better is to really replace "enum" by an integer (__u32?) at the structs,
but this will break existing apps.

One alternative would be to fork this header and add a compat layer
that would print a WARN_ONCE message, if ever reached, asking the user
to re-compile the application against the new header. 

We did that strategy in the past, appending _OLD to the legacy api ioctl's.

> 2) Add an version IOCTL that returns the current API level, so that
> the app can be written to support more than one API interface,
> depending on which kernel it is running on. The version IOCTL simply
> returns an u32 value. This is a consistent part of the user-kernel API
> that will never change.

There's one ioctl that already provides the API level, plus other info.
This ioctl doesn't contain any enum, so it is backward compatible.

> 3) Add "depreciated" compiler warnings to all the old API IOCTL calls,
> so app developers know they should be working to update their apps.

The issue here is with binaries compiled against the old headers. So, this
won't work.

> 4) After a few years, remove the old IOCTLs.
> 5) Use "uint32_t" and "uint64_t" types for all IOCTL calls, and not
> "unsigned int" or "unsigned long int".

No ioctls (well, except for 2 deprecated ones VIDIOC_G_JPEGCOMP/VIDIOC_S_JPEGCOMP)
are using __u8/__u32/__u64 for integers. The only issue there is with enum's.

> I.e. All structures passed in IOCTLs use fixed bit sized parameters
> for everything except of course pointers. Pointers depend on
> architecture.
> 6) Add a #if #endif around the old API, so a user compiling their own
> kernel can decide if the old API exists or not. User might want to do
> this for security reasons.

Add an #if block there will make the header very hard to deal with, as this
is already complex enough without it. The V4L2 API header has 2420 lines.
Such #if blocks will almost duplicate the header size.

I can see only two viable fixes for it:

1) add a typedef for the enum, using the sizeof(enum) in order to select the
size of the used integer.

Pros:
	- Patch is easy to write/easy to review;
	- Won't change the struct size, so applications compiled without
	  strong gcc optimization won't break;
Cons:
	- It will add a typedef, with is ugly;
	- struct size on 32 bits will be different thant he size on 64 bits
	  (not really an issue, as v4l2-compat32 will handle that;
	- v4l2-compat32 code may require changes.

2) just replace it by a 32 bits integer.

Pros:
	- no typedefs;
	- struct size won't change between 32/64 bits (except when they also
	  have pointers);
Cons:
	- will break ABI. So, a compat code is required;
	- will require a "videodev2.h" fork for the legacy API with the enum's;
	- will require a compat code to convert from enum into integer and
	  vice-versa.

Comments/Votes?
Mauro
