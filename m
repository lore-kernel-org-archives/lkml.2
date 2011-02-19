Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1BSLm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 06:42:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47255 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1BSLmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 06:42:53 -0500
Date: Sat, 19 Feb 2011 17:12:48 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Ryan Harper <ryanh@us.ibm.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>, bharata@in.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, kmr@us.ibm.com
Subject: Effect of nice value on idle vcpu threads consumption
Message-ID: <20110219114248.GA19999@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
	I have been experimenting with renicing vcpu threads and found some
oddity. I was expecting a idle vcpu thread to consume close to 0% cpu resource
irrespective of its nice value. That was true when nice value was 0 for vcpu
threads. However altering nice value of (idle) vcpu threads is causing its cpu 
consumption to shoot up. Does anyone have a quick answer to this behavior?

More details.

	Machine : x3650-M2 w/ 2 Quad-core CPUs (Intel Xeon X5570), HT enabled
	Host    : RHEL 6 distro w/ 2.6.38-rc5 kernel
	Single Guest : w/ 4vcpus (all vcpus pinned to physical cpu 0), 1GB mem
			Sles11 distro w/ 2.6.37 kernel

Single guest is booted and kept idle.


When all vcpu threads are at nice 0, here's the consumption (close to 0 for all
vcpu threads).


  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+   P COMMAND                                                                   
 5642 qemu      20   0 1567m 381m 3048 S  1.2  1.2   0:02.56  0 qemu-kvm
 5640 qemu      20   0 1567m 381m 3048 S  0.8  1.2   0:12.74  0 qemu-kvm
 5641 qemu      20   0 1567m 381m 3048 S  0.8  1.2   0:02.60  0 qemu-kvm
 5643 qemu      20   0 1567m 381m 3048 S  0.6  1.2   0:02.76  0 qemu-kvm

Changing nice value for one of the vcpu threads to -20:


  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+   P COMMAND                                                                   
 5640 qemu       0 -20 1567m 381m 3048 R 45.5  1.2   0:19.67  0 qemu-kvm
 5641 qemu      20   0 1567m 381m 3048 R  0.4  1.2   0:03.33  0 qemu-kvm
 5642 qemu      20   0 1567m 381m 3048 R  0.4  1.2   0:03.16  0 qemu-kvm
 5643 qemu      20   0 1567m 381m 3048 R  0.4  1.2   0:03.36  0 qemu-kvm
	
Changing nice value for another of the vcpu threads to -20:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+   P COMMAND                                                                   
 5640 qemu       0 -20 1567m 381m 3048 S 35.7  1.2   0:30.92  0 qemu-kvm
 5641 qemu       0 -20 1567m 381m 3048 S 26.1  1.2   0:04.77  0 qemu-kvm
 5642 qemu      20   0 1567m 381m 3048 S  0.2  1.2   0:03.29  0 qemu-kvm
 5643 qemu      20   0 1567m 381m 3048 S  0.2  1.2   0:03.50  0 qemu-kvm

Is this behavior expected? Any explanation for this behavior?

- vatsa
 

