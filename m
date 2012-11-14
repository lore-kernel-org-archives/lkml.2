Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422920Ab2KNNlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:41:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44772 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176Ab2KNNlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:41:04 -0500
Message-ID: <1352900468.9388.20.camel@joe-AO722>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Nov 2012 05:41:08 -0800
In-Reply-To: <1352895463-22851-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352895463-22851-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 14:17 +0200, Vladimir Kondratiev wrote:
> Introduce debug_hex_dump() that can be dynamically controlled, similar to
> pr_debug.

(added Jason Baron, Jim Cromie, GregKH and lkml to cc's)

[]
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -220,6 +220,20 @@ extern void dump_stack(void) __cold;
>  	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>  #endifD
>  
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> +		       groupsize, buf, len, ascii)		\
> +		       dynamic_hex_dump(prefix_str, prefix_type,\
> +					rowsize, groupsize, buf,\
> +					len, ascii)
> +#else
> +#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
> +		       groupsize, buf, len, ascii)		\
> +		       print_hex_dump(KERN_DEBUG, prefix_str,	\
> +				      prefix_type, rowsize,	\
> +				      groupsize, buf, len, ascii)
> +#endif

These should be in a different location after print_hex_dump
is declared. Also for #defines, the indentation doesn't
need to be so deep.

#if defined(CONFIG_DYNAMIC_DEBUG)
#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
		       groupsize, buf, len, ascii)		\
	dynamic_hex_dump(prefix_str, prefix_type,		\
			 rowsize, groupsize, buf, len, ascii)
#else
#define debug_hex_dump(prefix_str, prefix_type, rowsize,	\
		       groupsize, buf, len, ascii)		\
	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type,	\
		       rowsize, groupsize, buf, len, ascii)
#endif

A better option might be to convert print_hex_dump_bytes()
to dynamic_debug as that's already KERN_DEBUG.  That
could be simpler overall and it makes existing calls
become dynamic as well.

