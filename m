Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2HTSk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:40:57 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:37195 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2HTSkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:40:55 -0400
From: Jim Meyering <jim@meyering.net>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH] cifs: remove misleading strncpy: each name has length < 16
In-Reply-To: <CAE2SPAbBmRov9qK2HiBQBQXaZpfJ8pmZJ-PL18FEyoZhzDza4A@mail.gmail.com>
	(Bastien ROUCARIES's message of "Mon, 20 Aug 2012 19:36:26 +0200")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-6-git-send-email-jim@meyering.net>
	<CAE2SPAbBmRov9qK2HiBQBQXaZpfJ8pmZJ-PL18FEyoZhzDza4A@mail.gmail.com>
Date: Mon, 20 Aug 2012 20:40:10 +0200
Message-ID: <87628dmmph.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien ROUCARIES wrote:
> Le 20 août 2012 19:29, "Jim Meyering" <jim@meyering.net> a écrit :
>>
>> From: Jim Meyering <meyering@redhat.com>
>>
>> Each of the protocols[i].name strings (statically declared above)
>> has length less than 16, so this use of strncpy is misleading:
>>   strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
>> Besides, if a new name were added with length N >= 16, the existing
>> strncpy-using code would be buggy, creating a ->DialectsArray buffer
>> containing N-16+1 unset bytes where the NUL terminator should have
>> been.  Instead, traverse the name only once go get its length,
>> use a BUG_ON assertion to enforce the length restriction
>> and use memcpy to perform the copy.
>
> Could you use ARRAY_SIZE instead of hard coding 16?

Not that I can see: the DialectsArray member is declared like this:

    typedef struct negotiate_req {
            struct smb_hdr hdr;	/* wct = 0 */
            __le16 ByteCount;
            unsigned char DialectsArray[1];
    } __attribute__((packed)) NEGOTIATE_REQ;

...
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 074923c..16a9018 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -441,8 +441,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses
> *ses)
>>
>>         count = 0;
>>         for (i = 0; i < CIFS_NUM_PROT; i++) {
>> -               strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
>> -               count += strlen(protocols[i].name) + 1;
>> +               size_t len = strlen(protocols[i].name);
>> +               BUG_ON(len >= 16);
>> +               memcpy(pSMB->DialectsArray+count, protocols[i].name, len + 1);
>> +               count += len + 1;
