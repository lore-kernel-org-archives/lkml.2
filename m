Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2JPOjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:39:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59522 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2JPOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <5298100.2jQ2j2jhxN@avalon>
References: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
 <3084988.3Xup6S3alX@avalon> <CAB=NE6UUL+zCSMwy4yzZq7+3pDLxZNsusSvXyJv4gi3_rz2ugg@mail.gmail.com>
 <5298100.2jQ2j2jhxN@avalon>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 16 Oct 2012 07:38:39 -0700
X-Google-Sender-Auth: hEF8phNfeJogpr8kOFiMnJ4QuMY
Message-ID: <CAB=NE6VMxhE8O4J+OaKVNUjJqdBEiNkocvueGFn8Wsa8-AG_bQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] uapi: update includes for drm content when no kernel
 API exists
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, tglx@linutronix.de,
        daniel.vetter@ffwll.ch, jbarnes@virtuousgeek.org,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 5:34 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Luis,
>
> On Saturday 13 October 2012 10:00:42 Luis R. Rodriguez wrote:
>> On Sat, Oct 13, 2012 at 3:33 AM, Laurent Pinchart wrote:
>> > On Friday 12 October 2012 16:49:31 Luis R. Rodriguez wrote:
>> >> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>> >>
>> >> The UAPI changes split kernel API and userspace API
>> >> content onto two separate header files. The userspace
>> >> API drm content was moved to include/uapi/drm/ with the
>> >> same file name while kernel specific API content was
>> >> kept under include/drm/ with the same file name. When
>> >> one file was split into two files the kernel header
>> >> includes the uapi header and a UAPI prefix was added to
>> >> the uapi header for its header guard. When there was no
>> >> kernel API content found the uapi header file was the
>> >> only one that was kept and the original guard for the
>> >> header file was kept. In this particular case the
>> >> original users of this header file were not modified
>> >> and the uapi header file is expected to be picked up
>> >> by path.
>> >>
>> >> This may work well at compilation on the kernel but when
>> >> backporting this creates a few complexities.
>> >
>> > Could you please provide more details about those complexities ?
>>
>> Sure, the backported DRM code is as-is code from linux-next. The
>> header search path includes a copy of a few select header files from
>> linux-next, the rest are part of the compat [0] project to help with
>> backporting and the last set are from your own kernel. In this
>> particular case the UAPI effort pushed into include/uapi/drm a few
>> files which are now no longer present in the old include/drm/ location
>> when there was no respective kernel-only APIs exposed. For DRM code
>> that did not use the new uapi/drm/ path for old header includes this
>> means that upon backporting the older kernel's header file would be
>> used obviously leading to a series of compilation failures. By being
>> explicit about the path, as was done with a few other header files, we
>> can suck out DRM code intact from the kernel to be compilable for
>> older kernels. As of the v3.7-rc1 the compat-drivers project [1] will
>> be providing DRM modules. The new UAPI changes broke compilation on
>> compat-drivers when compiling DRM code so to fix this we either patch
>> code taken from the Linux kernel as I have done, force inclusion of a
>> few specific headers files, or use include_next tricks. It turns out
>> that forcing inclusion of -I$(M)/include/uapi as a path search prior
>> to your own kernel's at compilation time did not help.
>
> Shouldn't that be added as a search path *after* include/linux/ instead of
> before ?

Ah, therein lies the issue. If backporting no, if backporting you
should seek first for your current directory's include/drm/ dir and
then uapi, and then only later the older kernel's paths:

NOSTDINC_FLAGS := \
        -I$(M)/include/ \
        -I$(M)/include/drm \
        -I$(M)/include/uapi \
        -include $(M)/include/linux/compat-2.6.h \
        $(CFLAGS)

>> The include_next trick can work as well but that'd mean synching the UAPI
>> files regularly into compat. I'd much prefer to have code intact when
>> possible when backporting so the option I stuck with then was to patch
>> the code directly and then as part of compat-drivers to always copy
>> that day's linux-next UAPI headers into the current directory for
>> compilation. I see no other driver code using the uapi path explicitly
>> though, is that by design?
>
> As far as I understand that's by design, yes. Kernel code isn't expected to
> reference uapi/ headers directly.

Did the design consider the case where no respective kernel API header
file would ever exist?

>> Would it be wrong to be explicit about using a UAPI header alone if no
>> kernel API files exist?
>
> I personally don't really like including such "features" in a mainline just
> for backporting,

Sort of ditto. I haven't yet made a strong case for one particular
situation where this would help (but I will in the long run, see
blog), but this example should not be considered one. The patch itself
should be considered in terms of its merit for clarifying usage and
assumptions of uapi. The fact that I came up with it due to issues
when backporting is only secondary.

> especially when they go against the spirit of the
> architecture (the uapi/ split design principles in this case).

The patches, pull request, and even lwn article did not cover the
intent on architecture so if it was the design objective I'd like to
know how that is determined. From the looks of it, this as all
scripted and I do wonder if the case where no kernel API header file
existed was taken into consideration.

> The way we're
> dealing with this in the V4L backport tree
> (http://git.linuxtv.org/media_build.git) is to play with Makefiles, include
> compatibility headers and, if nothing else can work, maintain backport patches
> for mainline code.

Thanks for the heads up, I can certainly keep these patches as
external but when if I see something that typically may be addressed
upstream for non-backport purposes I typically post it for review. I
can't say I'm still satisfied with the answers.

Why would we restrict drivers with direct access to uapi headers,
specially when no kernel API header exists?

  Luis
