Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2APMRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:17:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:12546 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2APMRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:17:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="56873233"
Date: Mon, 16 Jan 2012 12:31:10 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, jeffrey.t.kirsher@intel.com,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
Message-ID: <20120116123110.7ce91f2d@bob.linux.org.uk>
In-Reply-To: <CANKRQnge1n4M7W5xCqwyGzXp8J3eK1HbZVRqGW7BoE5iOwYCDQ@mail.gmail.com>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
	<20120114.001430.787918662083526597.davem@davemloft.net>
	<4F11A533.4040406@linux.intel.com>
	<20120114.115604.2101782124431552110.davem@davemloft.net>
	<20120114214658.4ddfec30@pyramind.ukuu.org.uk>
	<4F120357.3020808@linux.intel.com>
	<CANKRQnge1n4M7W5xCqwyGzXp8J3eK1HbZVRqGW7BoE5iOwYCDQ@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Saving MAC address into external ROM is generic method, I think.
> Though I know the ROM-less system using eg20t-pch, however I think
> this system is not common.
> So, I think pch_gbe shouldn't have auto-mac address assignment.

The problem is the module load fails for those cases. You cannot load
the module and use the standard ifconfig eth0 hw aa:bb:cc:dd:ee:ff
interface. The better fix might be to make sure it loads.

So change from

        memcpy(netdev->dev_addr, adapter->hw.mac.addr,
        netdev->addr_len);   
        if (!is_valid_ether_addr(netdev->dev_addr)) {
                dev_err(&pdev->dev, "Invalid MAC Address\n");
                ret = -EIO; 
                goto err_free_adapter;
        }

to just printing a warning, and check the current address when a user
tries to ifconfig it up and refuse to allow the port to go active.

Alan
