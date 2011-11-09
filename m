Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1KIPNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:13:41 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:56507 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1KIPNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:13:40 -0500
X-AuditID: c1b4fb3d-b7c26ae0000035b9-c6-4eba98a273b4
Message-ID: <4EBA98A1.90902@ericsson.com>
Date: Wed, 9 Nov 2011 16:13:37 +0100
From: =?ISO-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com> <20111109144258.GD30472@aftab>
In-Reply-To: <20111109144258.GD30472@aftab>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 03:42 PM, Borislav Petkov wrote:
> On Wed, Nov 09, 2011 at 03:32:58PM +0100, Niklas Söderlund wrote:
>> Use a lookup table to calculate the size of a chip select. The old
>> method of calculating size return erroneous values for some memory
>> configurations.
>
> Can you elaborate more on those erroneous values, please?
>
> Thanks.
>

The decoding table from the documentation:

cs_mode		size (mb)
0		32
1		64
2		128
3		128
4		256
5		512
6		256
7		512
8		1024
9		1024
10		2048

The original code:

if (cs_mode == 3 || cs_mode == 8)
	return 32 << (cs_mode - 1);
else
	return 32 << cs_mode;

The code tries to compensate for the irregularity in the decoding table 
but fails for cs_mode greater or equal to 4. It fails because:

- It do not consider the cumulating effect of reoccurring sizes for all 
values of cs_mode. It only tries for the special cases and it only 
succeeds in one.

- It do not consider the out of order values of cs_mode values 4-7: 256, 
512, 256, 512.

Best Regards
// Niklas
