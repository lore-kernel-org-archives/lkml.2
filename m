Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2KWRtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:49:24 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62873 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab2KWRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:49:23 -0500
Message-ID: <1353692960.1420.26.camel@x61.thuisdomein>
Subject: Re: nouveau driver fails to build
From: Paul Bolle <pebolle@tiscali.nl>
To: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Date: Fri, 23 Nov 2012 18:49:20 +0100
In-Reply-To: <1353690805.30841.0@numa-i>
References: <1353681769.29421.0@numa-i>
	 <1353684679.1420.7.camel@x61.thuisdomein> <1353690805.30841.0@numa-i>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 17:49:20.0736 (UTC) FILETIME=[DDD71E00:01CDC9A2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 18:13 +0100, Helmut Jarausch wrote:
> On 11/23/2012 04:31:19 PM, Paul Bolle wrote:
> > On Fri, 2012-11-23 at 15:42 +0100, Helmut Jarausch wrote:
> > > with 3.7_rc6 and
> > >
> > > CONFIG_ACPI_VIDEO=m
> > > CONFIG_DRM=y
> > > CONFIG_DRM_KMS_HELPER=y
> > > CONFIG_DRM_TTM=y
> > > CONFIG_DRM_NOUVEAU=y
> > > CONFIG_NOUVEAU_DEBUG=5
> > > CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> > > CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> > >
> > > with/ without
> > > CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> > >
> > >
> > > The kernel fails to build with
> > > drivers/built-in.o: In function `nouveau_acpi_edid':
> > > (.text+0x12bf21): undefined reference to `acpi_video_get_edid'
> > >
> > >
> > > What am I missing?
> > 
> > I'd guess it should build (at least without this error) with
> > CONFIG_ACPI_VIDEO=y. Is that correct?
> 
> Yes, but this is very unnatural.
> 
> To get CONFIG_ACPI_VIDEO=y  I need to have VIDEO_OUTPUT_CONTROL=y
> for which I have to select the Intel GMA500 Stub Driver although I don't
> have such a device and therefore don't need that driver.
> Furthermore, I had to chase through quite some flags to find this.
> 
> If it's not a bug, it's surprising, at least.

0) It puzzles me too.

1) The problem is in Nouveau's Kconfig:
    config DRM_NOUVEAU
        tristate "Nouveau (nVidia) cards"
        [...]
        select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
        [...]

and its Makefile:
    # other random bits
    [...]
    nouveau-$(CONFIG_ACPI) += nouveau_acpi.o
    [...]

    obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o

2) Now, with DRM_NOUVEAU=y and ACPI_VIDEO=m nouveau_acpi.o will be made
builtin (which fails with the error Helmut ran into). The puzzling part
is that ACPI_VIDEO will only be selected (ie, made into a 'y') if all
dependencies of that select statement are 'y' too. (Note that these
dependencies are identical to the dependencies of ACPI_VIDEO's config
entry. That can be no coincidence.)

3) But I would expect ACPI_VIDEO to be selected if the dependencies of
that select statement are either 'y' or 'm'. And then Helmut's .config
should trigger some warning about selecting a symbol with unmet
dependencies, or whatever, shouldn't it? (Because some of ACPI_VIDEO's
dependencies are still 'm'.)

4) I'm CC-ing the Kconfig people to tell us whether the current behavior
is as designed or a bug. If it's not a bug the DRM_NOUVEAU config entry
might need to be changed.


Paul Bolle

