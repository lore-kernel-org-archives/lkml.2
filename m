Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0EUUIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:08:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0EUUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:08:44 -0400
Date: Fri, 21 May 2010 13:08:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, andi.kleen@intel.com,
       cl@linux-foundation.org, fengguang.wu@intel.com, mel@csn.ul.ie,
       tj@kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       minskey guo <chaohong.guo@intel.com>
Subject: Re: [PATCH] cpu_up: hold zonelists_mutex when build_all_zonelists
Message-Id: <20100521130808.919ecb35.akpm@linux-foundation.org>
In-Reply-To: <4BF4AB24.7070107@linux.intel.com>
References: <201005192322.o4JNMu5v012158@imap1.linux-foundation.org>
	<4BF4AB24.7070107@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 11:23:16 +0800
Haicheng Li <haicheng.li@linux.intel.com> wrote:

> 
> Here is another issue, we should always hold zonelists_mutex when calling build_all_zonelists
> unless system_state == SYSTEM_BOOTING.

Taking a global mutex in the cpu-hotplug code is worrisome.  Perhaps
because of the two years spent weeding out strange deadlocks between
cpu-hotplug and cpufreq.

Has this change been carefully and fully tested with lockdep enabled
(please)?

> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -357,8 +357,11 @@ int __cpuinit cpu_up(unsigned int cpu)
>                  return -ENOMEM;
>          }
> 
> -       if (pgdat->node_zonelists->_zonerefs->zone == NULL)
> +       if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
> +               mutex_lock(&zonelists_mutex);
>                  build_all_zonelists(NULL);
> +               mutex_unlock(&zonelists_mutex);
> +       }

Your email client is performing space-stuffing and it replaces tabs
with spaces.  This requires me to edit the patches rather a lot,
which is dull.


