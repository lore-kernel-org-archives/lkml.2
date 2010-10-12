Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0JLR2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:28:19 -0400
Received: from mail.agmk.net ([91.192.224.71]:41660 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0JLR2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:28:18 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.35/drm/radeon] screen blinking during compositing (kde4/effects).
Date: Tue, 12 Oct 2010 19:28:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34; KDE/4.5.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010121928.10353.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with the new 2.6.35 kernel release i have new problems with aiglx/kde4/effects
on my old radeon card (lspci) ATI Technologies Inc RV370 secondary [Sapphire X550 Silent].

at the first place, kwin manager decides to disable compositing
at all and logs on the console something like this:

(...)
kwin(3129) KWin::CompositingPrefs::detectDriverAndVersion: GL vendor is "DRI R300 Project"
kwin(3129) KWin::CompositingPrefs::detectDriverAndVersion: GL renderer is "Mesa DRI R300 (RV380 5B63) 20090101  TCL DRI2"
kwin(3129) KWin::CompositingPrefs::detectDriverAndVersion: GL version is "1.5 Mesa 7.8.2"
kwin(3129) KWin::CompositingPrefs::detectDriverAndVersion: Detected driver "radeon" , version "20090101"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_login"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_translucency"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_boxswitch"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_fadedesktop"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_desktopgrid"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_slidingpopups"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_fade"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_dialogparent"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_taskbarthumbnail"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_presentwindows"
kwin(3129) KWin::EffectsHandlerImpl::unloadEffect: EffectsHandler::unloadEffect : Unloading Effect :  "kwin4_effect_logout"
kwin(3129) KWin::Extensions::init: Extensions: shape: 0x "11"  composite: 0x "4"  render: 0x "b"  fixes: 0x "40"
kwin(3129) KWin::Workspace::setupCompositing: Initializing OpenGL compositing
kwin(3129) KWin::Workspace::setupCompositing: KWin has detected that your OpenGL library is unsafe to use, falling back to XRender.
kwin(3129): Failed to initialize compositing, compositing disabled
(...)

so, quick googling and following entry in ~/.kde/share/config/kwinrc forces compositing again.

[Compositing]
AnimationSpeed=3
Backend=OpenGL
CheckIsSafe=false              <===
DisableChecks=true             <===
Enabled=true
GLDirect=true
GLMode=TFP
GLTextureFilter=0
GLVSync=false
HiddenPreviews=5
OpenGLIsUnsafe=false           <===
XRenderSmoothScale=false

at this point compositing seems to work, it's still smooth but i'm observing an ugly screen blinking.
modprobing drm module with debug=1 gives on 2.6.35 additional logs about vblank events during compositing:

(...)
[  211.675593] [drm:drm_ioctl], pid=2842, cmd=0xc0206466, nr=0x66, dev 0xe200, auth=1
[  211.675663] [drm:drm_ioctl], pid=2842, cmd=0xc0086464, nr=0x64, dev 0xe200, auth=1
[  211.675674] [drm:drm_ioctl], pid=2842, cmd=0xc008646a, nr=0x6a, dev 0xe200, auth=1
[  211.675678] [drm:drm_ioctl], ret = fffffff0
[  211.675680] [drm:drm_ioctl], pid=2842, cmd=0xc0206466, nr=0x66, dev 0xe200, auth=1
[  211.675724] [drm:drm_ioctl], pid=2766, cmd=0xc018643a, nr=0x3a, dev 0xe200, auth=1
[  211.675728] [drm:drm_wait_vblank], waiting on vblank count 212705, crtc 0
[  211.675731] [drm:drm_wait_vblank], returning 212705 to client
[  211.675734] [drm:drm_ioctl], pid=2766, cmd=0xc018643a, nr=0x3a, dev 0xe200, auth=1
[  211.675737] [drm:drm_wait_vblank], waiting on vblank count 212705, crtc 0
[  211.675739] [drm:drm_wait_vblank], returning 212705 to client
[  211.675741] [drm:drm_ioctl], pid=2766, cmd=0xc018643a, nr=0x3a, dev 0xe200, auth=1
[  211.675744] [drm:drm_queue_vblank_event], event on vblank count 212706, current 212705, crtc 0
[  211.689126] [drm:drm_handle_vblank_events], vblank event on 212706, current 212706
[  211.689162] [drm:drm_ioctl], pid=2766, cmd=0xc008646a, nr=0x6a, dev 0xe200, auth=1
[  211.689172] [drm:drm_ioctl], pid=2766, cmd=0xc0086464, nr=0x64, dev 0xe200, auth=1
[  211.691457] [drm:drm_ioctl], pid=2766, cmd=0xc0206466, nr=0x66, dev 0xe200, auth=1
[  212.214162] [drm:drm_ioctl], pid=2766, cmd=0xc008646a, nr=0x6a, dev 0xe200, auth=1
(...)

is it a kernel bug or a feature?

BR,
Pawel.

ps).
i'm using following xorg/mesa packages from my distro:

Mesa-dri-driver-ati-radeon-R300-7.8.2-2.x86_64
Mesa-libGL-7.8.2-2.x86_64
Mesa-libGLU-7.8.2-2.x86_64
Mesa-utils-7.8.2-2.x86_64
(...)
xorg-driver-input-evdev-2.5.0-1.x86_64
xorg-driver-video-ati-6.13.2-1.x86_64
(...)
xorg-lib-libdmx-1.1.0-2.x86_64
xorg-lib-libfontenc-1.0.5-1.x86_64
xorg-lib-libICE-1.0.6-1.x86_64
xorg-lib-libpciaccess-0.12.0-1.x86_64
xorg-lib-libSM-1.1.1-1.x86_64
xorg-lib-libX11-1.3.6-1.x86_64
xorg-lib-libXau-1.0.6-1.x86_64
xorg-lib-libXaw-1.0.7-3.x86_64
xorg-lib-libXcomposite-0.4.2-1.x86_64
xorg-lib-libXcursor-1.1.10-2.x86_64
xorg-lib-libXdamage-1.1.3-1.x86_64
xorg-lib-libXdmcp-1.0.3-1.x86_64
xorg-lib-libXext-1.1.2-1.x86_64
xorg-lib-libXfixes-4.0.5-1.x86_64
xorg-lib-libXfont-1.4.2-1.x86_64
xorg-lib-libXfontcache-1.0.5-2.x86_64
xorg-lib-libXft-2.1.14-2.x86_64
xorg-lib-libXi-1.3.2-1.x86_64
xorg-lib-libXinerama-1.1-2.x86_64
xorg-lib-libxkbfile-1.0.6-2.x86_64
xorg-lib-libXmu-1.0.5-2.x86_64
xorg-lib-libXp-1.0.0-5.x86_64
xorg-lib-libXpm-3.5.8-2.x86_64
xorg-lib-libXrandr-1.3.0-3.x86_64
xorg-lib-libXrender-0.9.6-1.x86_64
xorg-lib-libXres-1.0.4-2.x86_64
xorg-lib-libXScrnSaver-1.2.0-2.x86_64
xorg-lib-libXt-1.0.8-1.x86_64
xorg-lib-libXtst-1.1.0-2.x86_64
xorg-lib-libXv-1.0.5-2.x86_64
xorg-lib-libXvMC-1.0.6-1.x86_64
xorg-lib-libXxf86dga-1.1.1-2.x86_64
xorg-lib-libXxf86misc-1.0.2-2.x86_64
xorg-lib-libXxf86vm-1.1.0-2.i686
xorg-lib-libXxf86vm-1.1.0-2.x86_64
xorg-proto-kbproto-devel-1.0.5-1.x86_64
xorg-proto-xproto-devel-7.0.18-1.x86_64
xorg-xserver-libdri-1.9.0-1.x86_64
xorg-xserver-libglx-1.9.0-1.x86_64
xorg-xserver-server-1.9.0-1.x86_64
