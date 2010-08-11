Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0HKMt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 08:49:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0HKMt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 08:49:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [DRM] BUG: sleeping function called from invalid context, drm_lastclose
Date: Wed, 11 Aug 2010 14:49:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.sourceforge.net
References: <20100811084828.GA5709@nb-core2.darkstar.lan> <AANLkTimx0No2RgS8EdZCz=X8urJ8u4hVEVH5c1mcz_CW@mail.gmail.com>
In-Reply-To: <AANLkTimx0No2RgS8EdZCz=X8urJ8u4hVEVH5c1mcz_CW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008111449.48141.arnd@arndb.de>
X-Provags-ID: V02:K0:giS+R6EBJ5xGyI0BRcRGJ1wmrfb2WaJuFWbOovG4GSe
 bu5IYJS6HfqZfJIr/R34NM2u8dwIDSs/n7QfZ2LVuddMpwnNX4
 glIhadY5rNbI63lHO0k/hWSN+gX0viIlraY1doG7j/2LBBYvFl
 Xbvb3tuFglJ6UYIUmmkGRXvbfgEZ+d7Kuaxe4/10C69bjXTaTb
 Ge/DotcjpND0d0F8xYJkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 August 2010, Dave Airlie wrote:
> On Wed, Aug 11, 2010 at 6:48 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> >
> >
> > moved the call to (inside drm_release) drm_lastclose inside dev->count_lock
> > spinlock.
> > drm_lastclose however takes dev->struct_mutex (now inside an atomic
> > context):

Yes, that's obviously been broken by me, sorry about the trouble.

I must have been trying to simplify the error handling by adding a
goto at the end of drm_release, which then happened to break
the common path.

The easiest way to fix this would be to go back to the way drm_release()
worked previously and /only/ replace {,un}lock_kernel() with
mutex_{,un}lock(&drm_global_mutex);.

> I have a patch from Chris Wilson that I need to push to fix this,
> basically reducing the spin lock coverage,
> and relying on the global mutex to handle the open race.

Yes, that sounds good, it's what the code used to do before my broken
change.

You might also be able to find a way to remove drm_global_lock from the
open/close path entirely.

	Arnd
