Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0KIK1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:27:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52211 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0KIK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:27:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Sv+Vk2yHQ8ew5aU3+FUgyHCtfooQwvHSuupFSBjqBH/A9sQIS8YSX3FynNmhIXo3sA
         eE2hK/ntIjU/PqnQ/PYKP5IAs9OHqW6nGhYaZZGNK5m91jMdbGVGPphadK/sJg504CRr
         D7QdESzMjO2qsONLV6mPTLqDuQsLGUVZYmwkk=
Message-ID: <4CD92225.2070205@gmail.com>
Date: Tue, 09 Nov 2010 11:27:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Milton Miller <miltonm@bga.com>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PCI: xen-pcifront, fix PCI reference leak
References: <1288881090-27335-1-git-send-email-jslaby@suse.cz> <xenfront-reffix-fixreq@mdm.bga.com> <20101108163411.GA2638@dumpdata.com>
In-Reply-To: <20101108163411.GA2638@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 05:34 PM, Konrad Rzeszutek Wilk wrote:
> On Thu, Nov 04, 2010 at 12:27:07PM -0600, Milton Miller wrote:
>> On 2010-11-04 at about 14:31:30 Jiri Slaby wrote:
>>> Stanse found that when pdev is found and has no driver a reference is
>>> leaked in pcifront_common_process. So add pci_dev_put there. For the
>>> pdev == NULL case, pci_dev_put(NULL) is fine.
>>
>> While that may be true, the dev_err(&pcidev->dev ... is a NULL pointer
>> deref.
> 
> I've put the fix in the branch (stable/xen-pcifront-fixes) that I will ask Linus
> to pull.. but what options did you need to find this?
> 
> I tried to run this before putting your and Milton fix in:
> konrad@phenom:~/tar/stanse-1.1.2$ java -jar ./stanse.jar  ~/work/linux/drivers/pci/xen-pcifront.c 
> Stanse version "1.1.2"
> Copyright (c) 2008-2010 Masaryk University, Brno
> 
> STANSE_HOME not specified. Using the location of stanse.jar.
> Checking for bugs:
> <-> File: /home/konrad/work/linux/drivers/pci/xen-pcifront.c
> <-> --------------------------------
> Done.
> 
> And no warnings?

It's not easy as that. You have to specify checkers like
-c
AutomatonChecker:dist/data/checkers/AutomatonChecker/kernel_pairing.xml
-c AutomatonChecker:dist/data/checkers/AutomatonChecker/kernel_memory.xml
etc. Then, probably stanse won't guess kernel build flags correctly, so
you need to utilize kernel make system. So the command-line (from linux
src dir) would be:
STANSE_HOME=PATH java -jar PATH/stanse.jar -c
AutomatonChecker:PATH/dist/data/checkers/AutomatonChecker/kernel_pairing.xml
-c
AutomatonChecker:PATH/dist/data/checkers/AutomatonChecker/kernel_memory.xml
--makefile Makefile --make-params 'drivers/pci/xen-pcifront.o'

Presumably drivers/pci/xen-pcifront.o must not exist so that when stanse
runs make, it actually builds something. It will warn you about that anyway.

Maybe you want to run with gui: -g to track the issues in gui. There you
can also add the checkers by hand (or on cmdline too).

For openSUSE, I package stanse into rpm, and there is a script which has
-k and adds all the kernel checkers by default.

regards,
-- 
js
