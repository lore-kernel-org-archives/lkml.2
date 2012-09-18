Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2IRAvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:51:07 -0400
Received: from nm.newmedia-net.de ([217.113.179.122]:36405 "EHLO
	webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2IRAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:51:05 -0400
Message-ID: <5057C3DC.9090003@dd-wrt.com>
Date: Tue, 18 Sep 2012 02:44:12 +0200
From: "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: XHCI Bug discovered in 3.6-RC6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this following function is missing a important NULL check. if DMI is not 
available or not enabled in the kernel config (which is common in my 
case, since its a ARM Platform with XHCI support)
the xhci-hcd driver will crash due nullpointer access since 
dmi_get_system_info returns always NULL if DMI support is not enabled.

proposed patch: simply add  to this function
  if (!dmi_sys_vendor || !dmi_product_name)
         return false;

even better. disable the whole quirk handling for this case if 
CONFIG_DMI is not set

static bool compliance_mode_recovery_timer_quirk_check(void)
{
     const char *dmi_product_name, *dmi_sys_vendor;

     dmi_product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
     dmi_sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);

     if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
         return false;

     if (strstr(dmi_product_name, "Z420") ||
             strstr(dmi_product_name, "Z620") ||
             strstr(dmi_product_name, "Z820"))
         return true;

     return false;
}


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

