Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0LTSK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:10:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40769 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab0LTSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=M+bqJcNq+VD05drmkgruKBCn4IU/hKPAcK1EPSv1tw+nUZ5lyOC5ckt6jpTo2mly7h
         px1PUnu5rHEKE9/Og41YDLSyRGGGmWlwCPsRlClfmYwhBiYKBKZqhRzD8oNiK0fG+Mqf
         Dn+i2G09W1LOzQit79NVyEnNG7c8WIyQmp6p0=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 20 Dec 2010 13:10:03 -0500
X-Google-Sender-Auth: FZcQrYt5Qiqn1pHloqE4vwaNtwA
Message-ID: <AANLkTikaxPEszPPU=J1bP2TitrrDuhZ=FZKbD2hwD+VH@mail.gmail.com>
Subject: 2.6.36.2 regression: suspend on Lenovo X200s broken due to TPM
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change "PNPACPI: cope with invalid device IDs", added in 2.6.36.2,
makes the kernel detect my TPM (it used to not work at all), but the
TPM driver doesn't work because it can't autodetect the iTPM
workaround.  This breaks suspend without actually fixing my TPM.

On boot, I get:

[   11.159923] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[   11.165033] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
[   11.171020] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
[   11.177021] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5

and on suspend I get:

[   67.918108] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
[   67.918116] legacy_suspend(): pnp_bus_suspend+0x0/0x85 returns -5
[   67.918120] PM: Device 00:0a failed to suspend: error -5
[   68.174167] PM: Some devices failed to suspend

tpm_tis.itpm=1 fixes it, as does upstream commit
3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 (tpm: Autodetect itpm
devices)

Greg (and mjg): can you either revert the PNPACPI fix in 2.6.36.3 or
add the upstream fix?

The offending commit is:

commit 47bbe7b5e827946c7b560b1917cd8cbdbe6d84b7
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sat Sep 18 10:11:09 2010 -0700

    PNPACPI: cope with invalid device IDs

    commit 420a0f66378c84b00b0e603e4d38210102dbe367 upstream.

    If primary ID (HID) is invalid try locating first valid ID on compatible
    ID list before giving up.

    This helps, for example, to recognize i8042 AUX port on Sony Vaio VPCZ1
    which uses SNYSYN0003 as HID. Without the patch users are forced to
    boot with i8042.nopnp to make use of their touchpads.

    Tested-by: Jan-Hendrik Zab <jan@jhz.name>
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

The fix is:

commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27
Author: Matthew Garrett <mjg@redhat.com>
Date:   Thu Oct 21 17:42:40 2010 -0400

    tpm: Autodetect itpm devices

    Some Lenovos have TPMs that require a quirk to function correctly. This can
    be autodetected by checking whether the device has a _HID of INTC0102. This
    is an invalid PNPid, and as such is discarded by the pnp layer - however
    it's still present in the ACPI code, so we can pull it out that way. This
    means that the quirk won't be automatically applied on non-ACPI systems,
    but without ACPI we don't have any way to identify the chip anyway so I
    don't think that's a great concern.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
    Tested-by: Jiri Kosina <jkosina@suse.cz>
    Tested-by: Andy Isaacson <adi@hexapodia.org>
    Signed-off-by: James Morris <jmorris@namei.org>

This applies cleanly to 2.6.36.2, reports "tpm_tis 00:0a: Intel iTPM
workaround enabled" and makes my laptop suspend again.

Thanks,
Andy
