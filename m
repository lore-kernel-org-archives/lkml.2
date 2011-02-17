Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1BQRWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:22:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40342 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1BQRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZauYMbj8fECK7Y0s8nqoRWZXXZevy2FQtDdTr/bg0QGFQ3TA5nUbD74xV2fUoPw/uK
         63YSbUfoJmbpfsDLmFUoXztMCUiclU440EAWChk7dyRaIL5E503xamb4OttQiSjg3usP
         Ss2G9NUIRjx4CHUP4D3WeiINDpxgu4AbdvfVA=
Date: Thu, 17 Feb 2011 09:21:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable Dell All-In-One volume up/down keys
Message-ID: <20110217172158.GA21932@core.coreip.homeip.net>
References: <1297688524-26123-1-git-send-email-colin.king@canonical.com>
 <20110217075256.GB19814@core.coreip.homeip.net>
 <1297941011.2234.32.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297941011.2234.32.camel@lenovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:10:11AM +0000, Colin Ian King wrote:
> Thanks for your feedback Dmitry,
> 
> On Wed, 2011-02-16 at 23:52 -0800, Dmitry Torokhov wrote:
> > Hi Colin,
> > 
> > On Mon, Feb 14, 2011 at 01:02:04PM +0000, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > Enable volume up and down hotkeys on WMI events
> > > GUID 284A0E6B-380E-472A-921F-E52786257FB and
> > > GUID 02314822-307C-4F66-bf0E-48AEAEB26CC8.
> > > 
> > > Also works around a firmware bug where the _WED method
> > > should return an integer containing the key code and in fact
> > > the method returns the key code in element zero of a buffer.
> > > 
> > > BugLink: http://bugs.launchpad.net/bugs/701530
> > > BugLink: http://bugs.launchpad.net/bugs/676997
> > 
> > Looks generally good, one question though - should't it be part of
> > dell-wmi driver?
> 
> Good question.  A couple of points:
> 
> 1. The Dell All-In-One WMI hotkey mechanism is a little different from
> the
> normal Dell WMI hotkey mechanism, so I didn't really want to clutter up
> the
> Dell WMI driver with exceptions for these particular GUIDs and notifier
> IDs.
> 
> 2. These keys appear on a very limited subset of Dell machines, so
> keeping
> this code out of the Dell WMI driver for the majority of Dell machines
> will
> keep the original Dell WMI driver smaller. 
> 
> 3. I expect further additions in functionality for these machines, which
> makes sense to keep it specific to this limited All-In-One driver.
> 
> As it stands, this All-In-One interface has already been implemented by
> two different BIOS vendors and already there are two different
> implementations. I'd like to keep this all in one specific driver for
> this class of machine if possible.

OK, fair enough.

> From 7a4c2b706317df9be5b7514934e87412fa64eaf4 Mon Sep 17 00:00:00 2001
> From: Colin Ian King <colin.king@canonical.com>
> Date: Thu, 17 Feb 2011 10:49:30 +0000
> Subject: [PATCH] Enable Dell All-In-One volume up/down keys
> 
> Enable volume up and down hotkeys on WMI events
> GUID 284A0E6B-380E-472A-921F-E52786257FB4 and
> GUID 02314822-307C-4F66-bf0E-48AEAEB26CC8.
> 
> Also works around a firmware bug where the _WED method
> should return an integer containing the key code and in fact
> the method returns the key code in element zero of a buffer.
> 
> BugLink: http://bugs.launchpad.net/bugs/701530
> BugLink: http://bugs.launchpad.net/bugs/676997
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks much better, but I just noticed that we are missing calls to
sparse_keymap_free(dell_wmi_aio_input_dev) in both probe error handling
path and in remove method (they shoudl be called before unregistering
the device).

Also, can we have probe routine more streamlined, like this:

static int __init dell_wmi_aio_init(void)
{
	int err;
	char *guid;

	guid = dell_wmi_aio_find();
	if (!guid) {
		pr_error("No known WMI GUID found\n");
		return -ENXIO;
	}

	err = dell_wmi_aio_input_setup();
	if (err)
		return err;

	err = wmi_install_notify_handler(guid, dell_wmi_aio_notify, NULL);
	if (err) {
		pr_err("Unable to register notify handler - %d\n", err);
		sparse_keymap_free(dell_wmi_aio_input_dev);
		input_unregister_device(dell_wmi_aio_input_dev);
		return err;
	}

	return 0;
}

Thanks.

-- 
Dmitry
