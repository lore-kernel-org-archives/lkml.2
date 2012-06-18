Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2FRLpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:45:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63878 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRLpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:45:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-GEVwdCmZTsToBN04B3Kxjrjp39C9j7it7cT4vX639nA@mail.gmail.com>
References: <CAOiN93=S4jEBJGwDfrTCsQQ2Yzm_BOGHT_pOivcdAkx5gTLxjA@mail.gmail.com>
	<alpine.LFD.2.00.1206181300470.2394@dhcp-1-248.brq.redhat.com>
	<CAKYAXd-GEVwdCmZTsToBN04B3Kxjrjp39C9j7it7cT4vX639nA@mail.gmail.com>
Date: Mon, 18 Jun 2012 20:45:17 +0900
Message-ID: <CAKYAXd-kdSgH2LuGk=_cGZaYpOZRUaAthTCPi-Y7JYETPJLd2g@mail.gmail.com>
Subject: Re: Punching hole using fallocate is not removing the uninit extent
 from extent tree
From: Namjae Jeon <linkinjeon@gmail.com>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>, linux-ext4@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in mail loop.

2012/6/18, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/6/18, Lukáš Czerner <lczerner@redhat.com>:
>> On Mon, 28 May 2012, Ashish Sangwan wrote:
>>
>>> Date: Mon, 28 May 2012 19:38:05 +0530
>>> From: Ashish Sangwan <ashishsangwan2@gmail.com>
>>> To: linux-ext4@vger.kernel.org
>>> Subject: Punching hole using fallocate is not removing the uninit extent
>>> from
>>>     extent tree
>>
>> Hi Ashish,
>>
>> I am looking at you patch, however I am not able to reproduce this.
>> Can you please send more information (script preferably) on how to
>> reproduce this problem ?
>>
> Hi. Lukas.
> If you use the below script, you can easily reproduce this problem.
> And I can not attach script file, so I write script code in this mail.
> you can paste it to file.
>
> fragmentation.sh
> -----------------------------------------------------------------------
> dd if=/dev/zero of=12kb bs=4096 count=6
> index=0
> while [ $? == 0 ]
> do
> index=$(($index + 1))
> cp 12kb $1/file1.$index
> done
> echo "Partition filled"
> sync
> df -h
> index=0
> while [ $? == 0 ]
> do
> index=$(($index + 2))
> sync
> rm  $1/file1.$index
> done
> sync
> echo "fragmented partition $1 with 4KB files"
> -------------------------------------------------------------------------
>
> 1. create smaill partition(500MB) to reproduce rapidly.
> 2. plz run this script to make fragmentation partition after making
> dummy directory like this.
> mkdir test_dir
> ./fragmentation.sh test_dir
>
> 3. dd if=/dev/zero of=d_file bs=1024 count=10240
> 4. you can see file depth is not zero.(dump_extents d_file
> 5. and try to fallocate offset : 4096 lengh 4096.
>
>> Also what kernel version did try this on ?
> We are using 3.0.20 kernel patched your punch hole patches.
>
> Please let us know in case of any queries.
>
> Thanks.
>
>>
>> Thanks!
>> -Lukas
>>
>>>
>>> I have created a formatted EXT4 partition such that every single
>>> extent is exactly 6blocks (24KB) of length.
>>> I used hole punch on 2 different files.
>>>
>>> CASE 1: In first situation, file size is 72KB. There are total 3
>>> extents each 24KB length. Using fallocate to punch hole starting at
>>> offset 4096 and length 4096,
>>> dump_extents gives the following expected output :
>>>
>>> Before punching hole :
>>> Level Entries       Logical      Physical Length Flags
>>> 0/ 0   1/  2     0 -     5  1856 -  1861      6
>>> 0/ 0   2/  2     6 -    11  1868 -  1873      6
>>>
>>> After punching hole :
>>> Level Entries       Logical      Physical Length Flags
>>> 0/ 0   1/  3     0 -     0  1856 -  1856      1
>>> 0/ 0   2/  3     2 -     5  1858 -  1861      4
>>> 0/ 0   3/  3     6 -    11  1868 -  1873      6
>>>
>>> The 1st extent: 0-5, is splitted into 3 extents, "0-0", "1-1", "2-5"
>>> Extent 1-1 is first marked as uninitialized in function
>>> ext4_ext_map_blocks() and later removed from the extent tree by
>>> ext4_ext_remove_space().
>>>
>>> CASE 2: File size is 9.4MB. There are total 400 extents each 24KB
>>> length, depth of extent tree at root header is 1 and there are 2 index
>>> entries.
>>>
>>> dump_extents output before punching hole:
>>> Level Entries       Logical      Physical Length Flags
>>> 0/ 1   1/  2     0 -  2039  1922           2040
>>> 1/ 1   1/340     0 -     5  1856 -  1861      6
>>> 1/ 1   2/340     6 -    11  1868 -  1873      6
>>> < Continued likewise till 340/340 >
>>> 1/ 1 340/340  2034 -  2039  5942 -  5947      6
>>> 0/ 1   2/  2  2040 -  2399  1923            360
>>> 1/ 1   1/ 60  2040 -  2045  5954 -  5959      6
>>> 1/ 1   2/ 60  2046 -  2051  5966 -  5971      6
>>> < Continued likewise till 60/60 >
>>> 1/ 1  60/ 60  2394 -  2399  6662 -  6667      6
>>>
>>> dump_extents output after punching hole :
>>> 0/ 1   1/  3     0 -     5  1922              6
>>> 1/ 1   1/  3     0 -     0  1856 -  1856      1
>>> 1/ 1   2/  3     1 -     1  1857 -  1857      1 Uninit
>>> 1/ 1   3/  3     2 -     5  1858 -  1861      4
>>> 0/ 1   2/  3     6 -  2039  6674           2034
>>> 1/ 1   1/339     6 -    11  1868 -  1873      6
>>> 1/ 1   2/339    12 -    17  1880 -  1885      6
>>> < Continued like wise...>
>>>
>>> Comparing CASE2 with CASE1, still uninit extent "1-1" is present
>>> within the extent tree.
>>>
>>> In function ext4_ext_remove_space(), there is call to function
>>> ext4_ext_rm_leaf which is responsible for removal of this extent.
>>> But this function is not getting called in CASE 2 :
>>> if (i == depth) {
>>>                        /* this is leaf block */
>>>                        err = ext4_ext_rm_leaf(handle, inode, path,
>>>                                        start, end);
>>> /* root level has p_bh == NULL, brelse() eats this */
>>>                        brelse(path[i].p_bh);
>>>                        path[i].p_bh = NULL;
>>>                        i--;
>>>                        continue;
>>>                }
>>>
>>> Varibale "i" does not become equals to "depth" because
>>> ext4_ext_more_to_rm is returning "0" hence the following if condition
>>> is turning out to be false for 1st extent index:
>>> if (ext4_ext_more_to_rm(path + i)) {
>>>
>>> Looking at the defination of ext4_ext_more_to_rm :
>>> /*
>>> * ext4_ext_more_to_rm:
>>> * returns 1 if current index has to be freed (even partial)
>>> */
>>> static int
>>> ext4_ext_more_to_rm(struct ext4_ext_path *path)
>>> {
>>>        BUG_ON(path->p_idx == NULL);
>>>        if (path->p_idx < EXT_FIRST_INDEX(path->p_hdr))
>>>                return 0;
>>>
>>>        /*
>>>         * if truncate on deeper level happened, it wasn't partial,
>>>         * so we have to consider current index for truncation
>>>         */
>>>        if (le16_to_cpu(path->p_hdr->eh_entries) == path->p_block) <=
>>> This condition is turning out to be true
>>>                return 0;       <= The function is returning zero from
>>> here.
>>>        return 1;
>>> }
>>>
>>> I could not understand the significance of the above mentioned if
>>> condition check, if anyone could explain a little, it will be help.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
