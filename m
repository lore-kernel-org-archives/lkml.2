Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab0LMAeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:34:36 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:39166 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0LMAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:34:34 -0500
Date: Sun, 12 Dec 2010 18:34:11 -0600
From: David Fries <david@fries.net>
To: Florian Mickler <mickler@fzi.de>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] [correction] load fbcon from drm_kms_helper
Message-ID: <20101213003411.GM13567@spacedout.fries.net>
References: <20101212183921.GA25744@spacedout.fries.net>
 <20101212230128.47c20b10@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101212230128.47c20b10@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 12 Dec 2010 18:34:14 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:01:28PM +0100, Florian Mickler wrote:
> On Sun, 12 Dec 2010 12:39:22 -0600
> David Fries <david@fries.net> wrote:
> 
> > Kconfig says fbcon is required by drm_kms_helper.  If radeon, fbcon,
> > and drm_kms_helper are all modules, radeon is auto loaded (by PCI id?),
> > drm_kms_helper is loaded because of the module dependency, but fbcon
> > isn't loaded leaving the console unusable.  Since fbcon is required
> > and there isn't an explicit module dependency, request the module
> > to be loaded from drm_kms_helper.
> > 
> > Signed-off-by: David Fries <david@fries.net>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > ---
> > The last patch had a typo 'namue', mental reminder, test again after
> > running checkpatch.pl.
> > 
> > This solves compiling CONFIG_FB=m and being left with a blank screen
> > because the radeon module is automatically loaded, but fbcon isn't.
> > If radeon had to be manually loaded, then it would be the user's fault
> > for
> > not loading fbcon as well, but as radeon is being loaded
> > automatically,
> > there isn't much a user can do from console to even fix it.  More bug
> > details from here,
> > https://bugzilla.kernel.org/show_bug.cgi?id=16221
> 
> I guess this is reasonable. Maybe _if_ there actually is a usecase for
> a drm driver without fbcon, the drm could provide a
> parameter to skip loading fbcon?

My question was more, is there a usecase for a drm driver with
the fbcon module available, but not wanting it loaded?

> But also the drm Kconfig seems to be bogus? SELECT is not transitiv. 
> So selecting DRM_KMS_HELPER is not enough, as it will not select FB
> and FRAMEBUFFER_CONSOLE. Maybe the drm drivers that currently
> select DRM_KMS_HELPER should instead depend on it.  

But the "select FB" and "select FRAMEBUFFER_CONSOLE if !EMBEDDED"
Kconfig for DRM_KMS_HELPER is the mechanism that cause FB and
FRAMEBUFFER_CONSOLE to be compiled.  The was the other part of my
reasoning, if there is a case for drm without fbcon, DRM_KMS_HELPER
shouldn't force fbcon to be compiled.  But as it does require fbcon to
be compiled, and things are clearly broken if a drm driver is loaded
(radeon) but fbcon isn't loaded (no usable console) DRM_KMS_HELPER
should try to load it, hence the patch.

Just for a check I used `make xconfig` to verify they are
automatically selected.
set FB, DRM_RADEON, DRM etc to =n so FRAMEBUFFER_CONSOLE can also be set to =n
set DRM=m (FRAMEBUFFER_CONSOLE still =n)
set DRM_RADEON=m (DRM_KMS_HELPER, FB, and FRAMEBUFFER_CONSOLE become =m)
That's because DRM_RADEON sets DRM_KMS_HELPER, and DRM_KMS_HELPER selects
FB and FRAMEBUFFER_CONSOLE
config DRM_RADEON
	select DRM_KMS_HELPER
config DRM_KMS_HELPER
	select FB
	select FRAMEBUFFER_CONSOLE if !EMBEDDED
and FRAMEBUFFER_CONSOLE is forced to =m 

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
