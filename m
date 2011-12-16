Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab1LPBwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:52:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab1LPBwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:52:31 -0500
From: Thomas Renninger <trenn@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] ACPI: EC: Add ec_get_handle()
Date: Fri, 16 Dec 2011 02:52:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com> <201112160122.36100.trenn@suse.de> <20111216003333.GA18489@srcf.ucam.org>
In-Reply-To: <20111216003333.GA18489@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112160252.26681.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 December 2011 01:33:33 Matthew Garrett wrote:
> On Fri, Dec 16, 2011 at 01:22:35AM +0100, Thomas Renninger wrote:
> 
> > I think best is to move the thinkpad implementation of getting
> > ACPI handles based on HIDs to osl.c and make it global.
> > I'll send patches.
> > Please review them carefully, they are only compile tested.
> 
> The ec driver is already finding the hardware on the basis of the HID - 
> is there any reason to do this twice rather than just exporting the 
> information the ec driver already has?
Exporting the EC handle is static, you do not want to export all
kind of ACPI devices as soon as other drivers need them.

The question is how long it takes to do:
acpi_ns_walk_namespace(ACPI_TYPE_DEVICE, ...
in worst case (not found).

Ok, the EC may be somewhat special because it's the most likely
candidate to get shared (or say needed by other drivers)
and its driver has to be compiled in.
.
thinkpad_acpi should at least also make use of Seth's approach and get the
ec_handle quickly/directly.

And my patches should still be added, because others could use
them as well. Beside thinkpad_acpi grabbing the video handle, there
is another re-implementation of my acpi_handle_locate (eeepc_wmi.c):
static acpi_status eeepc_wmi_parse_device(acpi_handle handle, u32 level,
                                                 void *context, void **retval)
{
        pr_warn("Found legacy ATKD device (%s)\n", EEEPC_ACPI_HID);
        *(bool *)context = true;
        return AE_CTRL_TERMINATE;
}

static int eeepc_wmi_check_atkd(void)
{
        acpi_status status;
        bool found = false;

        status = acpi_get_devices(EEEPC_ACPI_HID, eeepc_wmi_parse_device,
                                  &found, NULL);

        if (ACPI_FAILURE(status) || !found)
                return 0;
        return -1;                                                                                                                                                    
}


If you agree I can send something tomorrow.


    Thomas
