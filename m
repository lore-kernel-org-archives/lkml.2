Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1HOAE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:04:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47159 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1HOAEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:04:25 -0400
Message-ID: <4E486268.60205@parallels.com>
Date: Sun, 14 Aug 2011 17:03:52 -0700
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: <linux-kernel@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        David Chinner <david@fromorbit.com>,
        <containers@lists.linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        James Bottomley <JBottomley@parallels.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] parse options in the vfs level
References: <1313334832-1150-1-git-send-email-glommer@parallels.com> <1313334832-1150-5-git-send-email-glommer@parallels.com> <20110814153930.GA3996@albatros>
In-Reply-To: <20110814153930.GA3996@albatros>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.191.100.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 08:39 AM, Vasiliy Kulikov wrote:
> Hi Glauber,
>
> On Sun, Aug 14, 2011 at 19:13 +0400, Glauber Costa wrote:
>> +/**
>> + * Generic option parsing for the VFS.
>> + *
>> + * Since most of the filesystems already do their own option parsing, and with
>> + * very few code shared between them, this function strips out any options that
>> + * we succeed in parsing ourselves. Passing them forward would just give the
>> + * underlying fs an option it does not expect, leading it to fail.
>> + *
>> + * We don't yet have a pointer to the super block as well, since this is
>> + * pre-mount. We accumulate in struct vfs_options whatever data we collected,
>> + * and act on it later.
>> + */
>> +static int vfs_parse_options(char *options, struct vfs_options *ops)
>> +{
>> +	substring_t args[MAX_OPT_ARGS];
>> +	int option;
>> +	char *p;
>> +	char *opt;
>> +	char *start = NULL;
>> +	int ret;
>> +	
>> +	if (!options)
>> +		return 0;
>> +
>> +	opt = kstrdup(options, GFP_KERNEL);
>> +	if (!opt)
>> +		return 1;
>> +	
>> +	ret = 1;
>> +
>> +	start = opt;
>> +	while ((p = strsep(&opt, ",")) != NULL) {
>> +		int token;
>> +		if (!*p)
>> +			continue;
>> +
>> +		/*
>> +		 * Initialize args struct so we know whether arg was
>> +		 * found; some options take optional arguments.
>> +		 */
>> +		args[0].to = args[0].from = 0;
>> +		token = match_token(p, tokens, args);
>> +		switch (token) {
>> +		case 1:
>> +			if (!args[0].from)
>> +				break;
>> +
>> +			if (match_int(&args[0],&option))
>> +				break;
>
> What if there are 2 passed options and the second fails?
>
>     mount -o vfs_dcache_size=XXX,vfs_dcache_size=CRAP<dev>  <mntpoint>
>
> In this case you leave the second option and pass it to the fs option
> parser (as you already set ret=0), which is wrong.  I think you should
> explicitly return 1 where you know the option is related to VFS, but you
> failed to parse it.  It would look even simplier than current code.

Good point, thank you. I agree.

> (Yes, this is a rare situation, but I can imagine some program that
> automatically adds mount options to the existing list and passes it to
> mount.)
>
Absolutely.
