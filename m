Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1IHIFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab1IHIFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:05:45 -0400
Message-ID: <4E687754.1040005@redhat.com>
Date: Thu, 08 Sep 2011 10:05:40 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/2] staging: zram: fix zram locking
References: <1315314132-8436-1-git-send-email-jmarchan@redhat.com> <4E681BC9.4010901@vflare.org>
In-Reply-To: <4E681BC9.4010901@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 03:35 AM, Nitin Gupta wrote:
> On 09/06/2011 09:02 AM, Jerome Marchand wrote:
>> Currently init_lock only prevents concurrent execution of zram_init_device()
>> and zram_reset_device() but not zram_make_request() nor sysfs store functions.
>>
> 
> zram_make_request() initializes the device first time it is used and 
> from then on no sysfs config writes are allowed till the device is reset 
> -- for example, you cannot change disksize while a disk is in 
> initialized state. So, I could not understand why we need to protect 
> zram_make_request vs sysfs stores.

This is true for disksize_store() (which can race with zram_init_device(), thus
the write lock in it), not for reset_store(), which obviously can happen in
initialized state. I have actually hit those races with the following
reproducer:

---
#! /bin/sh

while true; do
    for i in `seq 0 9`; do
	echo 1 > /sys/block/zram0/reset&
	echo $((1024*1024*500)) > /sys/block/zram0/disksize&
	for i in `seq 1 10`; do
	    dd if=/dev/zero of=/dev/zram0 bs=4k count=1 2>/dev/null;
	done
    done;
    wait;
done


> 
> Thanks,
> Nitin
> 
> 
> 

