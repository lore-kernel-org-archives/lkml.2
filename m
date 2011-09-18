Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1IRWYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 18:24:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33595 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932589Ab1IRWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 18:24:24 -0400
Date: Sun, 18 Sep 2011 23:23:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alex Deucher <alexdeucher@gmail.com>,
        Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110918232329.6ff05d56@lxorguk.ukuu.org.uk>
In-Reply-To: <201109180112.15896.laurent.pinchart@ideasonboard.com>
References: <1316088425.11294.78.camel@lappyti>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<201109180112.15896.laurent.pinchart@ideasonboard.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This would leave us with the issue of controlling formats and other parameters 
> on the pipelines. We could keep separate DRM, KMS, FB and V4L APIs for that, 

There are some other differences that matter. The exact state and
behaviour of memory, sequencing of accesses, cache control and management
are a critical part of DRM for most GPUs, as is the ability to have them
in swap backed objects and to do memory management of them. Fences and
the like are a big part of the logic of many renderers and the same
fencing has to be applied between capture and GPU, and also in some cases
between playback accelerators (eg MP4 playback) and GPU.

To glue them together I think you'd need to support the use of GEM objects
(maybe extended) in V4L. That may actually make life cleaner and simpler
in some respects because GEM objects are refcounted nicely and have
handles.

DRM and KMS abstract out stuff into what is akin to V4L subdevices for
the various objects the video card has that matter for display - from
scanout buffers to the various video outputs, timings and the like.

I don't know what it's like with OMAP but for some of the x86 stuff
particularly low speed/power stuff the capture devices, GPU and overlays
tend to be fairly incestuous in order to do things like 1080i/p preview
while recording from the camera.

GPU is also a bit weird in some ways because while its normally
nonsensical to do things like use the capture facility one card to drive
part of another, it's actually rather useful (although not supported
really by DRM) to do exactly that with GPUs. A simple example is a dual
headed box with a dumb frame buffer and an accelerated output both of
which are using memory that can be hit by the accelerated card. Classic
example being a USB plug in monitor.
