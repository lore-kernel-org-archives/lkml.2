Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1KGXGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:06:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56849 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1KGXGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:06:44 -0500
MIME-Version: 1.0
In-Reply-To: <20111107151939.GA24234@thunk.org>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
	<20111107151939.GA24234@thunk.org>
Date: Tue, 8 Nov 2011 08:06:43 +0900
Message-ID: <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in
 fill_super and remount.
From: NamJae Jeon <linkinjeon@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/8 Ted Ts'o <tytso@mit.edu>:
> On Mon, Nov 07, 2011 at 11:01:51PM +0900, Namjae Jeon wrote:
>> Fix NULL pointer dereference from orig_data in fill_super and remount.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>
> Um, did you even try to test this patch before submitting it?
>
> #1:   kstrdup() return NULL if data is NULL
>
> #2:  The kernel's printk and sprintf functions will translate
>     sprintf(buf, "%s", NULL) by filling in the string "NULL"
>
> #3:  The only use of orig_data is a cosmetic one, of printing out
>     the mount options which are passed in.
>
> #4:  If the user doesn't specify any mount options, data is NULL, and
>     your patch would cause those mounts to fail with ENOMEM.
>
> In summary, there is no problem here; a pendant might complain that
> it's possible for data to be non-NULL, and for orig_data to be null of
> the kstrdup failed, but in that case, other memory allocations done
> later in ext4_fill_super() will almost have certainly failed, so in
> practice won't get as far as the printk.
Hi. Ted.
Sorry, I will make a patch next time after testing. Thanks for your review.
And I checked how to handle this case in other filesystem.

btrfs try to handle like this.
------------------------------------------------------------------------------
	if (!options)
		goto out;

	/*
	 * strsep changes the string, duplicate it because parse_options
	 * gets called twice
	 */
	opts = kstrdup(options, GFP_KERNEL);
	if (!opts)
		return -ENOMEM;
-------------------------------------------------------------------------------

So I suggest that ext4 try to handle like this.
-------------------------------------------------------------------------------
        if(data) {
                orig_data = kstrdup(data, GFP_KERNEL);
                if(!orig_data)
                        return ret;
        }
-------------------------------------------------------------------------------
I want to know your opinion.
Thanks.
>
>                                        - Ted
>
