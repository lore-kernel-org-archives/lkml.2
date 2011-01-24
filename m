Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1AXXjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:39:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42027 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1AXXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PZyY5X+67sXcIEZINkH8OGdXuiuJjNrvYUOk+Rgna8bC0SzGqbGHZ4wMGQPSVktduH
         3CT7DQFh6GSBHIeH6/o8ekSgq0+IXRAvOqc0nGu+hTLJgeS9ppTdkQXQnl9wgAR413hl
         KSZwAiJxxd6IaAXdR5aTUce9V0xnPglYaclnI=
Date: Tue, 25 Jan 2011 00:38:35 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Bisected drm regression: 'xrandr --auto' does not turn on LVDS1
Message-ID: <20110124233835.GA1888@Pilar.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit bf9dc102e28 ("drm: Set connector DPMS status to ON in 
drm_crtc_helper_set_config") causes a regression in my laptop.

I always use the laptop connected to an external monitor,
so after booting I turn off the laptop panel with

xrandr --output LVDS1 --off

When I need to use the panel back, I turn it on with

xrandr --auto

That used to work in 2.6.36 and previous kernels, but no longer works
in 2.6.37 nor 2.6.38-rc2. The panel is turned off with the first command,
but 'xrandr --auto' does not turn it on again.

So I bisected the problem and arrived at the above commit (I did not
check whether reverting it from 2.6.37 or 2.6.38-rc2 also fixes the problem,
though).

>From lspci -v:

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
        Subsystem: Sony Corporation Device 9005
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at 1800 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 3
        Kernel driver in use: i915

The output of xrandr in 2.6.38-rc2 (which has the problem):

Pilar:/home/mafra/bin # xrandr
Screen 0: minimum 320 x 200, current 1680 x 1050, maximum 8192 x 8192
LVDS1 connected 1280x800+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1280x800       59.9*+
   1024x768       85.0     75.0     70.1     60.0
   832x624        74.6
   800x600        85.1     72.2     75.0     60.3     56.2
   640x480        85.0     72.8     75.0     59.9
   720x400        85.0
   640x400        85.1
   640x350        85.1
VGA1 connected 1680x1050+0+0 (normal left inverted right x axis y axis) 473mm x 296mm
   1680x1050      59.9*+   60.0
   1280x1024      75.0     60.0
   1440x900       75.0     59.9
   1280x960       60.0
   1152x864       75.0
   1024x768       75.1     60.0
   832x624        74.6
   800x600        75.0     60.3     56.2
   640x480        75.0     60.0
   720x400        70.1
TV1 unknown connection (normal left inverted right x axis y axis)
   848x480        30.0 +
   640x480        30.0 +
   1024x768       30.0
   800x600        30.0


I can gladly test patches and provide more info if needed.
