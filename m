Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1LRV2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:28:45 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36321 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1LRV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:28:43 -0500
Message-ID: <4EEE5B08.8010703@gmail.com>
Date: Sun, 18 Dec 2011 16:28:40 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ryota Ozaki <ozaki.ryota@gmail.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com>
In-Reply-To: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/18/11 6:58 AM), Ryota Ozaki wrote:
> /sys/devices/system/node/{online,possible} involve a garbage byte
> because print_nodes_state returns content size + 1. To fix the bug,
> the patch changes the use of cpuset_sprintf_cpulist to follow the
> use at other places, which is clearer and safer.
> 
> This bug was introduced since v2.6.24.
> 
> Signed-off-by: Ryota Ozaki<ozaki.ryota@gmail.com>
> ---
>   drivers/base/node.c |    8 +++-----
>   1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 5693ece..ef7c1f9 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -587,11 +587,9 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
>   {
>   	int n;
> 
> -	n = nodelist_scnprintf(buf, PAGE_SIZE, node_states[state]);
> -	if (n>  0&&  PAGE_SIZE>  n + 1) {
> -		*(buf + n++) = '\n';
> -		*(buf + n++) = '\0';
> -	}
> +	n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);

PAGE_SIZE-1. This seems another off by one. buf[n++] = '(J\n' mean
override old trailing '\0' and buf[n] = '\0' mean to append one byte.
Then totally, we append one byte.

> +	buf[n++] = '(B\n';
> +	buf[n] = '\0';
>   	return n;
>   }
> 

