Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0KKNnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:43:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64619 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0KKNni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eKZz5lctiEZ+jykS1us5oow8dzivlGAmJt0SuZ6qPqq0McDuGlQKy64PTsQ19k6xWW
         MrXkgzvG4ppIl5n61vn/aY26TaB9LSv0TgIbjROkmtOQpJFn1RRgrCuKUUz8NVrFdPVN
         6hwVh0VFskuZHU6OsN8hnA0ee5v4aPA1RM+vI=
MIME-Version: 1.0
In-Reply-To: <20101110151823.GC18258@parisc-linux.org>
References: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
	<20101110151823.GC18258@parisc-linux.org>
Date: Thu, 11 Nov 2010 21:43:36 +0800
Message-ID: <AANLkTin_ac34CT9gqSRfJm3qHG1NUjp=HC=G2ncVnAoL@mail.gmail.com>
Subject: Re: [PATCH] fix vulnerability of the release method of file
 operations in Block layer SCSI generic driver
From: Hillf Danton <dhillf@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:18 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Nov 10, 2010 at 10:08:37PM +0800, Hillf Danton wrote:
>> The computation context setup by previous opening the bsg file could
>> not survive following open/release operations upon the same file
>> object.
>
> Umm .. release is called on final close of a file, not on every close
> of a file.
>
right, thanks//Hillf

>> The vulnerability is fixed by deferring the cleanup operation until necessary.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/block/bsg.c     2010-09-13 07:07:38.000000000 +0800
>> +++ b/block/bsg.c     2010-11-10 21:43:58.000000000 +0800
>> @@ -858,7 +858,8 @@ static int bsg_release(struct inode *ino
>>  {
>>       struct bsg_device *bd = file->private_data;
>>
>> -     file->private_data = NULL;
>> +     if (1 == atomic_read(&bd->ref_count))
>> +             file->private_data = NULL;
>>       return bsg_put_device(bd);
>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
