Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2G2Sid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:38:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40752 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753330Ab2G2Sic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:38:32 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18XfC5IvckXHOdbIBR/88Kt3Yusigao1CiN8BLUz4
	/jrtrVsWftE39+
Message-ID: <50158321.4030007@gmx.net>
Date: Sun, 29 Jul 2012 20:38:25 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: bhelgaas@google.com, lenb@kernel.org
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody, 

this simple patch series continues the work begun in commit 
18fd470a48396c8795ba7256c5973e92ffa25cb3 where ACPI PNP resource templates 
with empty/disabled resources are handled.  

The aim of this patch series is to allow to set resources as "disabled" using 
the "/sys/bus/pnp/devices/*/resources" interface.  Such "disabled" resources 
are needed by some vintage IBM ThinkPads like the 600E where some devices need 
to have their IRQs disabled in order to support all the devices the 600E has. 

To better understand the motivation, let's look at an excerpt from the 600E's 
DSDT:

    Name (PLPT, ResourceTemplate ()
    {
        StartDependentFnNoPri ()
        {
            IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
            IRQNoFlags () {7}
        }
        /* Some entries deleted */
        StartDependentFnNoPri ()
        {
            IO (Decode16, 0x03BC, 0x03BC, 0x01, 0x04)
            IRQNoFlags () {}
        }
        EndDependentFn ()
    })

As one can see, the IRQ line for the last option is empty/disabled.  Also, both 
options share the same priority, meaning they are equal alternatives.  In order 
to be able to use the IRQ 7 for some other device, it is necessary to select 
the second option, which can be done with the patch series applied.

To this end, some preparatory work is done, simplifying the code, and fixing a
potential issue when explicitely assigning resources. 

Here is a brief description of these patches. 

[1/3] - Factor out common some code
[2/3] - Perform the actual setting
[3/3] - Handle IORESOURCE_BITS in resource allocation

The patches are applied against Linux 3.5.x. 

Comments are, as always, welcome.  If the patches should be sent to someone
else, please let me know. 


--- Witold


Changes from previous versions:

V3 -> V2: Added Bjorn Helgaas as "Reviewed by"
          No changes in the code itself
          Based on Linux 3.5.x

V1 -> V2: Split [V1 2/3] into [V2 2/3] and [V2 3/3]
          Removed [V1 3/3], will be submitted separately
          Wrote more comments in response to the previous version
          Sent to a broader audience
          (https://lkml.org/lkml/2012/4/11/442)

V1:       Initial version 
          (https://lkml.org/lkml/2012/3/20/358)
