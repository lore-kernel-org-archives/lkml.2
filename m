Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0LJUqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:46:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:47816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab0LJUqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:46:04 -0500
Message-ID: <4D029162.1040205@kernel.org>
Date: Fri, 10 Dec 2010 21:45:22 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-14-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092230010.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012092230010.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 20:45:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On 12/09/2010 10:43 PM, Thomas Gleixner wrote:
>> There are several places where using numa_cpu_node() is awkward and
>> the override doesn't matter.  In those places, __apicid_to_node[] are
>> used directly.
> 
> Why is it awkward? Anything outside the accessor functions or
> specialized setup code using it is awkward, inconsistent and sloppy.

There are two places which index the mapping by apicid instead of cpu.
One is acpi_fake_nodes() - this sets up the table, so it doesn't
constitute violation of accessors.

The problematic one is the nearby detection workaround in
kernel/cpu/amd.c.  This is rather hacky and looks like added to deal
with early AMD NUMAs which had broken BIOS.  The intel counterpart
omits this workaround and simply ignore NUMA configuration in those
cases.

I can change srat_detect_node() and nearby_node() to index by cpu but
as I have no idea what kind of broken configurations this is supposed
to deal with, I'm concerned that this may lead to different outcome by
walking the table in a different order.  I can implement an apicid ->
numa node mapping function for this but this is something which is
inherently ugly, so maybe it's best to leave it ugly.

For now, how about adding a big fat comment explaining the ugliness in
amd.c?

Thanks.

-- 
tejun
