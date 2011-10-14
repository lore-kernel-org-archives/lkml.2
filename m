Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1JNR0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:26:12 -0400
Received: from re04.intra2net.com ([82.165.46.26]:44270 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1JNR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:26:11 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 13:26:11 EDT
Message-ID: <4E9870A8.2010905@intra2net.com>
Date: Fri, 14 Oct 2011 19:26:00 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [slabinfo PATCH] Fix off-by-one after readlink() call
References: <4E9869B4.6080702@intra2net.com> <alpine.DEB.2.00.1110141214270.6411@router.home>
In-Reply-To: <alpine.DEB.2.00.1110141214270.6411@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 07:16 PM, Christoph Lameter wrote:
>> index 868cc93..cc1a378 100644
>> --- a/tools/slub/slabinfo.c
>> +++ b/tools/slub/slabinfo.c
>> @@ -1145,7 +1145,7 @@ static void read_slab_dir(void)
>>  		switch (de->d_type) {
>>  		   case DT_LNK:
>>  			alias->name = strdup(de->d_name);
>> -			count = readlink(de->d_name, buffer, sizeof(buffer));
>> +			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
>>
> 
> DESCRIPTION
>        readlink()  places  the  contents  of the symbolic link path in the buffer buf, which has size bufsiz.  readlink() does not append a
>        null byte to buf.  It will truncate the contents (to a length of bufsiz characters), in case the buffer is too small to hold all  of
>        the contents.

The problem is the line after the readlink() call:

buffer[count] = '\0';

The common technique is to reduce the buffer size by one.
Another fix would be to check

"
if (count < 0 || count == sizeof(buffer))
    fatal();
"

Reducing the buffer size by one is easier IMHO.

Cheers,
Thomas
