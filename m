Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2FYDiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 23:38:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38373 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2FYDiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 23:38:06 -0400
Message-ID: <4FE7DD19.8070106@gmail.com>
Date: Sun, 24 Jun 2012 21:38:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, ryanh@linux.vnet.ibm.com
Subject: Re: perf kvm segfaults while reporting events
References: <20120601135627.GA3004@linux.vnet.ibm.com> <4FC8E26E.7060309@gmail.com> <20120620061423.GB3488@linux.vnet.ibm.com>
In-Reply-To: <20120620061423.GB3488@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/12 12:14 AM, Pradeep Kumar Surisetty wrote:
>
> Ahhh perf kvm works fine if we record guest events for enough time.
> above patch works better, if some one doesnt record for adequate time.

Dumb luck. The extra time allows a sample that hits within a guest 
module and causes the build id for it to be added to the header.

I added some pr_debug's to the synthesize_modules. e.g.,

perf_event__synthesize_modules: host modules, pid -1, file 
/lib/modules/3.4.0/kernel/arch/x86/crypto/crc32c-intel.ko

perf_event__synthesize_modules: guest modules, pid 0, file 
/lib/modules/3.4.0/kernel/drivers/block/virtio_blk.ko

which is just wrong for the guest. It's a Fedora 17 VM where the kernel 
version is 3.4.0-1.fc17.x86_64 and even more important perf is not told 
where to find the modules (dso name in the event), so the dso path is 
based on the host OS.

Which comes back to my earlier comment: the 'default' guest options 
(--guestmodules here) for perf-kvm are busted. You really need to use 
the --guestmount option until perf-kvm gets some rework.

I will submit a patch to at least keep perf from segfaulting.

David
