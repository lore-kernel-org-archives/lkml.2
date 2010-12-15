Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0LOX2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:28:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0LOX2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:28:50 -0500
Message-ID: <4D094F1A.3020906@zytor.com>
Date: Wed, 15 Dec 2010 15:28:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 01/11] x86/kernel: remove conditional early remap in parse_e820_ext
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-2-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1290706801-7323-2-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 09:39 AM, Sebastian Andrzej Siewior wrote:
> parse_setup_data() uses early_memremap() for a PAGE_SIZE mapping in
> order to figure out the type & size. If this mapping is not large enough
> then parse_e820_ext() will remap this area again via early_ioremap()
> since the first mapping is still in use.
> 
> This patch attempts to simplify the handling and parse_e820_ext() does
> not need to worry about the mapping anymore.

I like the fact that this puts all the mapping in the same layer, but I
also think it's unfortunate to discard the optimization of always
mapping the minimum of <header length, rest of page>; your code will
*always* map-unmap-map the code, even in the (presumably very common)
case of the data fitting on a single page.

Furthermore, your code retains a minor bug from the original code, which
is that if the header is not page-aligned, it may be needlessly map more
than one page with unknown content.

The proper way to do it is probably (this is pseudocode):

maplen = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
             sizeof(struct setup_data));
data = early_memremap(pa_data, maplen);
len = data->len + sizeof(struct setup_data);
if (len > maplen) {
	early_iounmap(pa_data, maplen);
	data = early_memremap(pa_data, maplen);
}

/* ... */

early_iounmap(pa_data, maplen);

I also found your patch description to be needlessly hard to follow.
The key point is that it puts all the map manipulation into
parse_setup_data() where it belongs.  Since you're changing an
interface, however, also do note that you have checked that there are no
other callers to parse_e820_ext().

	-hpa
