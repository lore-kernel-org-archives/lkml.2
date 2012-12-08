Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2LHB3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:29:48 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19421 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2LHB3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:29:47 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 20:29:47 EST
Message-ID: <50C2947F.5030706@cavium.com>
Date: Fri, 07 Dec 2012 17:14:39 -0800
From: Aaron Williams <Aaron.Williams@cavium.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Williams, Aaron" <Aaron.Williams@caviumnetworks.com>
Subject: Incrementing module reference count
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2012 01:14:40.0288 (UTC) FILETIME=[65B7B200:01CDD4E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a kernel module which other modules register with in order to 
export access functions. So far I have everything working but I want to 
prevent a module that is registered with my module from unloading since 
now my module is dependent on the other module.

Is there a way I can cause the reference count of the module registering 
with my module to increase? I tried calling get_device with the device 
structure of the module that is registering but that does not seem to work.

For example, I have the following function:

/**
  * Adds a mapping of a device node to a memory accessor
  *
  * @param[in] dev - device
  * @param[in] macc - memory accessor
  *
  * @returns 0 for success or -ENOMEM
  */
int of_memory_accessor_register(struct device *dev,
                 struct memory_accessor *macc)
{
     struct of_macc_entry *mentry;

     mentry = kmalloc(sizeof(*mentry), GFP_KERNEL);
     if (mentry == NULL)
         return -ENOMEM;

     mentry->dev = dev;
     mentry->macc = macc;

     mutex_lock(&lock);

     get_device(dev);
     list_add(&(mentry->list), &macc_list);

     mutex_unlock(&lock);

     return 0;
}
EXPORT_SYMBOL(of_memory_accessor_register);

Basically my module is used for things like serial EEPROMs and whatnot 
so that external modules can find the accessor functions based on the 
device tree. In my case I am updating the Vitesse VSC848X driver so that 
it can read the SFP module when it is plugged in using the AT24 I2C 
EEPROM module. I want to prevent the at24 module from unloading while 
other modules in turn are using it. The at24 module does not export any 
symbols.

NOTE that I plan to change the above code so that I only increment the 
eeprom modules reference count when another module actually uses it and 
release it only when all other modules are no longer using the accessor 
functions.

I also am not subscribed to the LKML so please CC me on any responses.

-Aaron

-- 
Aaron Williams
Software Engineer
Cavium, Inc.
(408) 943-7198  (510) 789-8988 (cell)

