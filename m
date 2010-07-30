Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab0G3PQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:16:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45072 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0G3PQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:16:52 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.51.182]
In-Reply-To: <1280328333-31336-1-git-send-email-ernesto@ti.com>
References: <1280328333-31336-1-git-send-email-ernesto@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 30 Jul 2010 18:16:30 +0300
Message-ID: <AANLkTinhr8KhmJ9QMKeUHpPWsXuiBjZaFzHuwdrwww6=@mail.gmail.com>
Subject: Re: [PATCH 00/10] staging:ti dspbridge: Remove DSP_FAILED and 
	DSP_SUCCEEDED macros
To: Ernesto Ramos <ernesto@ti.com>
Cc: gregkh@suse.de, omar.ramirez@ti.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ernesto,

On Wed, Jul 28, 2010 at 5:45 PM, Ernesto Ramos <ernesto@ti.com> wrote:
> This series of patches is targetted to remove macros DSP_FAILED
> and DSP_SUCCEEDED since bridge driver currently uses standard kernel
> error codes.

These macros were often used to test for success, instead for errors.

This often leads to dspbridge code being highly nested, and hard to
read. The excessive indentation sometimes even lead to longer lines,
which were broken to meet the 80-chars recommendation, where the real
problem is actually the redundant indentation (e.g. check out this
patch http://www.mail-archive.com/linux-omap@vger.kernel.org/msg26700.html).

E.g. the following error testing is very common in the bridge code:

do_something1();
if (success) {
    do_something2();
    if (success) {
        do_something3();
        ....
    }
}

The kernel alternative would be to check for errors, and take error
paths out of the code flow, e.g.:

do_something1();
if (error)
    leave;

do_something2();
if (error)
    leave;

do_something3();
if (error)
    leave;

This leads to code which is much more easier to read.

If you could hunt some of those highly nested areas and make them test
for error instead of success, it can be really great.

Thanks,
Ohad.

>
> Ernesto Ramos (10):
>  staging:ti dspbridge: remove DSP_SUCCEEDED macro from core
>  staging:ti dspbridge: remove DSP_SUCCEEDED macro from pmgr
>  staging:ti dspbridge: remove DSP_SUCCEEDED macro from rmgr
>  staging:ti dspbridge: remove DSP_SUCCEEDED macro from services
>  staging:ti dspbridge: remove DSP_SUCCEEDED macro definition
>  staging:ti dspbridge: remove DSP_FAILED macro from core
>  staging:ti dspbridge: remove DSP_FAILED macro from pmgr
>  staging:ti dspbridge: remove DSP_FAILED macro from rmgr
>  staging:ti dspbridge: remove DSP_FAILED macro from services
>  staging:ti dspbridge: remove DSP_FAILED macro definition
>
>  drivers/staging/tidspbridge/core/chnl_sm.c         |   42 ++--
>  drivers/staging/tidspbridge/core/dsp-clock.c       |    4 +-
>  drivers/staging/tidspbridge/core/io_sm.c           |  111 +++++-----
>  drivers/staging/tidspbridge/core/msg_sm.c          |   26 ++--
>  drivers/staging/tidspbridge/core/tiomap3430.c      |   61 +++---
>  drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    8 +-
>  drivers/staging/tidspbridge/core/tiomap_io.c       |   41 ++--
>  .../staging/tidspbridge/include/dspbridge/dbdefs.h |    4 -
>  drivers/staging/tidspbridge/pmgr/chnl.c            |   10 +-
>  drivers/staging/tidspbridge/pmgr/cmm.c             |  137 ++++++-------
>  drivers/staging/tidspbridge/pmgr/cod.c             |   18 +-
>  drivers/staging/tidspbridge/pmgr/dbll.c            |   32 ++--
>  drivers/staging/tidspbridge/pmgr/dev.c             |   79 +++----
>  drivers/staging/tidspbridge/pmgr/dmm.c             |   12 +-
>  drivers/staging/tidspbridge/pmgr/dspapi.c          |   82 ++++----
>  drivers/staging/tidspbridge/pmgr/io.c              |    4 +-
>  drivers/staging/tidspbridge/pmgr/msg.c             |    2 +-
>  drivers/staging/tidspbridge/rmgr/dbdcd.c           |   48 ++--
>  drivers/staging/tidspbridge/rmgr/disp.c            |   62 +++---
>  drivers/staging/tidspbridge/rmgr/drv.c             |   39 ++--
>  drivers/staging/tidspbridge/rmgr/drv_interface.c   |   10 +-
>  drivers/staging/tidspbridge/rmgr/dspdrv.c          |   16 +-
>  drivers/staging/tidspbridge/rmgr/mgr.c             |   32 ++--
>  drivers/staging/tidspbridge/rmgr/nldr.c            |  106 +++++-----
>  drivers/staging/tidspbridge/rmgr/node.c            |  224 ++++++++++----------
>  drivers/staging/tidspbridge/rmgr/proc.c            |  137 ++++++------
>  drivers/staging/tidspbridge/rmgr/pwr.c             |   26 +--
>  drivers/staging/tidspbridge/rmgr/rmm.c             |   12 +-
>  drivers/staging/tidspbridge/rmgr/strm.c            |   75 ++++----
>  drivers/staging/tidspbridge/services/cfg.c         |   21 +-
>  30 files changed, 710 insertions(+), 771 deletions(-)
>
>
