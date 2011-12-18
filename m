Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1LRWoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:44:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54989 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1LRWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:44:27 -0500
Date: Sun, 18 Dec 2011 14:44:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ryota Ozaki <ozaki.ryota@gmail.com>
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
In-Reply-To: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com>
Message-ID: <alpine.DEB.2.00.1112181439500.1364@chino.kir.corp.google.com>
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Dec 2011, Ryota Ozaki wrote:

> /sys/devices/system/node/{online,possible} involve a garbage byte
> because print_nodes_state returns content size + 1. To fix the bug,
> the patch changes the use of cpuset_sprintf_cpulist to follow the
> use at other places, which is clearer and safer.
> 

It's not a garbage byte, sysdev files use a buffer created with 
get_zeroed_page(), so extra byte is guaranteed to be zero since 
nodelist_scnprintf() won't write to it.  So the issue here is that 
print_nodes_state() returns a size that is off by one according to 
ISO C99 although it won't cause a problem in practice.

> This bug was introduced since v2.6.24.
> 

It's not a bug, the result of a 4-node system would be "0-3\n\0" and 
returns 5 correctly.  You can verify this very simply with strace.
