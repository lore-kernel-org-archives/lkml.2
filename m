Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0IJLFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:05:01 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20068 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0IJLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:04:56 -0400
Date: Fri, 10 Sep 2010 14:04:46 +0300
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <david.woodhouse@intel.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: MTD: mtd_blkdevs regression
Message-ID: <20100910110446.GA28045@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Sep 2010 11:04:50.0075 (UTC) FILETIME=[FCDD66B0:01CB50D7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.34 modules using add_mtd_blktrans_dev() have reference
count 0 after loading and I can remove the module if it is not
being used. 

In 2.6.34, using mtdblock as an example:

    # modprobe nandsim
    # modprobe mtdblock
    # lsmod 
    Module                  Size  Used by
    mtdblock                2829  0 
    mtd_blkdevs             4217  1 mtdblock
    nandsim                25811  0 
    nand                   27184  1 nandsim
    nand_ids                2666  2 nandsim,nand
    nand_ecc                3392  1 nand
    mtd                    14794  5 mtd_blkdevs,nandsim,nand
    # rmmod mtdblock
    # 

Since commit 048d871 (mtd: blktrans: Hotplug fixes) in 2.6.35-rc1 
add_mtd_blktrans_dev() uses __get_module(tr->owner) to add reference 
count to calling module.

Because of this the module cannot be removed and since module
exit cannot be called, del_mtd_blktrans_dev() will not be called,
which would do the module_put().

In 2.6.35:

    # modprobe nandsim
    # modprobe mtdblock
    # lsmod
    Module                  Size  Used by
    mtdblock                2721  1 
    mtd_blkdevs             4895  1 mtdblock
    nandsim                25819  1 
    nand                   28326  1 nandsim
    nand_ids                2698  2 nandsim,nand
    nand_ecc                3400  1 nand
    mtd                    15352  5 mtd_blkdevs,nandsim,nand
    # rmmod mtdblock
    ERROR: Module mtdblock is in use
    #

Jarkko Lavinen
