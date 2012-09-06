Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2IFLtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2IFLtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:49:16 -0400
Message-ID: <50488DAD.3030208@redhat.com>
Date: Thu, 06 Sep 2012 13:49:01 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ric Wheeler <ricwheeler@gmail.com>
CC: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Ping^3] Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without
 CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <50195108.1090105@redhat.com> <503CA5BA.2040003@redhat.com> <50476480.9010302@redhat.com> <5047B38D.9000607@gmail.com> <50484345.8040508@redhat.com> <504889A1.2090507@gmail.com>
In-Reply-To: <504889A1.2090507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 13:31, Ric Wheeler ha scritto:
>>> Both of these commands are destructive. WRITE_SAME (if done without the
>>> discard bits set) can also take a very long time to be destructive and
>>> tie up the storage.
>>
>> FORMAT_UNIT has the same characteristics and yet it is allowed (btw, I
>> don't think WRITE SAME slowness is limited to the case where a real
>> write is requested; discarding can be just as slow).
>>
>> Also, the two new commands are anyway restricted to programs that have
>> write access to the disk.  If you have read-only access, you won't be
>> able to issue any destructive command (there is one exception, START
>> STOP UNIT is allowed even with read-only capability and is somewhat
>> destructive).
>>
>> Honestly, the only reason why these two commands weren't included, is
>> that the current whitelist is heavily tailored towards CD/DVD burning.
> 
> I assume that FORMAT_UNIT is for CD/DVD needs - not sure what a S-ATA
> disk would do with that.

According to the standard, the translation layer can write a
user-provided pattern to every sector in the disk.  It's an optional
feature and libata doesn't do that, but it is still possible.

> If it is destructive, we should probably think
> about how to make it more secure and see how many applications we would
> break.

We have filesystem permissions to make it secure.  They already do.

>>> I think that restricting them to CAP_SYS_RAWIO seems reasonable - better
>>> to vet and give the appropriate apps the needed capability than to
>>> widely open up the safety check?
>> CAP_SYS_RAWIO is so wide in its scope, that anything that requires it is
>> insecure.
> 
> I don't see allowing anyone who can open the device to zero the data as
> better though :)

Note: anyone who can open it for writing!  And they can just as well
issue WRITE, it just takes a little more effort than with WRITE SAME. :)
 If you only have read access, you cannot issue WRITE or FORMAT UNIT,
and with this patch you will not be able to issue WRITE SAME.

I'm all for providing more versatile filters---which can be both
stricter and looser depending on the configuration than the default.
For example
http://www.redhat.com/archives/libvir-list/2012-June/msg00505.html is a
possible spec for BPF-based filtering of CDBs.

However, the default whitelist (which is all we have for now) should
provide a reasonable default for a user that already has been granted
access to the device by the normal access control mechanisms.  I believe
WRITE SAME and UNMAP fit the definition of a reasonable default.

Paolo
