Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2LKMTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:19:10 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:31252 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:19:08 -0500
Message-ID: <50C7248F.8030409@huawei.com>
Date: Tue, 11 Dec 2012 20:18:23 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: WuJianguo <wujianguo@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/2] MCE: fix an error of mce_bad_pages statistics
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we use "/sys/devices/system/memory/soft_offline_page" to offline a
*free* page, the value of mce_bad_pages will be added, and the page is set
HWPoison flag, but it is still managed by page buddy alocator.

$ cat /proc/meminfo | grep HardwareCorrupted shows the value.

If we offline the same page, the value of mce_bad_pages will be added
*again*, this means the value is incorrect now. Assume the page is
still free during this short time.

soft_offline_page()
	get_any_page()
		"else if (is_free_buddy_page(p))" branch return 0
			"goto done";
				"atomic_long_add(1, &mce_bad_pages);"

Changelog:
V3:
	-add page lock when set HWPoison flag
	-adjust the function structure
V2 and V1:
	-fix the error

Xishi Qiu (2):
  move poisoned page check at the beginning of the function
  fix the function structure

 mm/memory-failure.c |   69 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 38 insertions(+), 31 deletions(-)

