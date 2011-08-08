Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1HHMzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:55:03 -0400
Received: from science.horizon.com ([71.41.210.146]:16541 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753807Ab1HHMzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:55:00 -0400
Date: 8 Aug 2011 08:54:59 -0400
Message-ID: <20110808125459.2961.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joakim.tjernlund@transmode.se, linux@horizon.com
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
In-Reply-To: <OF4BB89E7A.F9308AC6-ONC12578E6.00402167-C12578E6.0040598B@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> -#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> +#if CRC_LE_BITS > 8
> +# define LE_TABLE_SIZE 256
> +#else
> +# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> +#endif
> +#if CRC_BE_BITS > 8
> +# define BE_TABLE_SIZE 256
> +#else
> +# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> +#endif
> 
> -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> +#define LE_TABLE_ROWS ((CRC_LE_BITS - 1)/8 + 1)
> +#define BE_TABLE_ROWS ((CRC_BE_BITS - 1)/8 + 1)
> +
> +static uint32_t crc32table_le[LE_TABLE_ROWS][LE_TABLE_SIZE];
> +static uint32_t crc32table_be[BE_TABLE_ROWS][BE_TABLE_SIZE];

Minor cleanup suggestion: The two different ways of computing
xE_TABLE_SIZE and xE_TABLE_ROWS is a bit confusing.

May I recommend choosing one of the following:

#if CRC_LE_BITS > 8
# define LE_TABLE_ROWS (CRC_LE_BITS/8)
# define LE_TABLE_SIZE 256
#else
# define LE_TABLE_ROWS 1
# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
#endif

or

#define LE_TABLE_ROWS ((CRC_LE_BITS - 1)/8 + 1)
#define LE_TABLE_SIZE (1 << ((CRC_LE_BITS - 1)%8 + 1))

Either one makes the relationship between the two clearer.
