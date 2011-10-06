Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab1JFXI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:08:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51715 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab1JFXI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:08:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111006215046.GL31367@quack.suse.cz>
References: <CAOiN93m2OUnv95jpCT++Edv0yCwWG1mWa6uAYsuk2MGjKHZpJQ@mail.gmail.com>
	<20111006215046.GL31367@quack.suse.cz>
Date: Fri, 7 Oct 2011 08:08:56 +0900
Message-ID: <CAKYAXd9V5=Fb60QKkYJd0Emhf8ziMHDTmqAfm6RoApwtYQUJGg@mail.gmail.com>
Subject: Re: UDF alternate anchor block detection
From: NamJae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/7 Jan Kara <jack@suse.cz>:
>  Hello,
>
> On Fri 30-09-11 11:02:34, Ashish Sangwan wrote:
>> While mounting UDF media, when the primary AVDP is not found at block 256,
>> UDF code tries to read-in the alternate AVDP.
>> In the function udf_find_anchor, udf_scan_anchors is called 3 times, where
>> each call to udf_scan_anchors read 12 blocks.
>> In case there is no alternate AVDP stored, a total of 36 blocks are read
>> before mount fails - causing time delay for Mount Failure.
>>
>> After first call to udf_scan_anchors and before the second call there is
>> varconv conversion, for the older drivers, which skips 7 blocks after every
>> 32 blocks. What are these older drivers? Do we still require this code?
>  Frankly, I don't know what are these older drives. The code has been like
> this when I started maintaining it and I didn't want to introduce
> regressions so I kept the varconv code in.
>
>> After varconv conversion, why is there a third call to udf_scan_anchors? In
>> the 1st call and 3rd call to udf_scan_anchors, exactly same blocks are read,
>> so this 3rd call seems to be redundant.
>  This is not true - the second call uses
> udf_variable_to_fixed(sbi->s_last_block) as the last block on the media
> while the third call uses sbi->s_last_block as the last block on the media
> (both these scans are performed with varconv enabled). Again I have not
> seen a drive / medium where this would be needed but I believe original
> author had some reason to put the code in.
I agree. It would cause side-effect if old code is skipped without
knowing author's intent.
So It is correct to be kept this like now.
>
> I agree that the anchor searching code is a pain but that's how the
> standard is defined...
Actually, proper exception will be needed for metadata very slow loading disc.
I will share with you if there is good solution after considering.
Thanks.
>
>> I suggest this modified code for udf_find_anchor :-
>> lastblock =
>> udf_scan_anchors(sb,udf_variable_to_fixed(sbi->s_last_block),fileset);
>>         if (lastblock)
>>                 goto out;
>>          else {
>>                 /* VARCONV didn't help. Clear it. */
>>                 UDF_CLEAR_FLAG(sb, UDF_FLAG_VARCONV);
>>                 return 0;
>>         }
>>
>> Please give your opininon to these 2 above points. If the code change seems
>> relevant than I can make patch for it.
>
>                                                                Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
