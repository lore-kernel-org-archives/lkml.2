Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0IUKop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:44:45 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:52259 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269Ab0IUKoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:44:44 -0400
X-Quarantine-ID: <OUqQ-0CJwexo>
X-Amavis-Alert: BAD HEADER, Improper folded header field made up entirely of
	whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n jycPrvgA\n\t\n
	R1goSzOnkp14Y[...]
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
In-Reply-To: <4C97B079.8050707@gmx.de>
References: <20100919172833.14bf291e@neptune.home>	<4C963E99.9080207@gmx.de>
	 <20100919190240.65762511@neptune.home>  <4C97B079.8050707@gmx.de>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 12:44:35 +0200
Message-ID: <1285065875.8555.233.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 21:05 +0200, Florian Tobias Schandinat wrote: 
> 
> Bruno Prémont schrieb:
> > 
> > On Sun, 19 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> >>
> >> Bruno Prémont schrieb:
> >>> For USB-attached (or other hot-(un)pluggable) framebuffers the current
> >>> fbdev infrastructure is not very helpful. Each such driver currently
> >>> needs to perform the ref-counting on its own in .fbops.fb_open and
> >>> .fbops.fb_release callbacks.
> >> I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.
> > 
> > Yes, things like drmfb and drivers of multi-head capable framebuffer
> > drivers would certainly appreciate as well, but they will probably also
> > want to care about users (of fb_info.screen_base).
> 
> I don't see any special users of fb_info.screen_base. It's only used for 
> software fallbacks of acceleration functions and fb_read/fb_write (which I'd 
> consider rare to fb_mmap). The bad thing of screen_base is that it can make 
> viafb try to map up to 512MB on 32 bit systems...
> Much more painful IMHO are the mmaped areas in userspace which essentially 
> prevent moving around of the screen framebuffer inside the video ram.

Actually, FWIW, when I tried to fix the framebuffer being pinned at a
fixed location in VRAM all the time in radeondrmfb, the userspace
mappings didn't seem to be any particular problem thanks to TTM. The
problem was the framebuffer CPU access by fbcon, as it can happen from
pretty much any context. The only possible solution at this point seems
to be to prevent fbcon CPU access completely by providing accelerated
versions of all its relevant hooks.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
