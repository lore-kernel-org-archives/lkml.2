Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0EVSMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab0EVSMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:12:41 -0400
Message-ID: <4BF81D64.8000700@redhat.com>
Date: Sat, 22 May 2010 14:07:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       phillip@lougher.demon.co.uk, alain@knaff.lu, hpa@zytor.com
Subject: Re: [PATCH]: bunzip2: Fix warning in get_next_block()
References: <20100522135933.28675.17356.sendpatchset@prarit.bos.redhat.com> <20100522140741.GM31073@ZenIV.linux.org.uk>
In-Reply-To: <20100522140741.GM31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/22/2010 10:07 AM, Al Viro wrote:
> On Sat, May 22, 2010 at 10:04:07AM -0400, Prarit Bhargava wrote:
>    
>> Fix checkstack compile warning in get_next_block():
>>
>> lib/decompress_bunzip2.c: In function `get_next_block':
>> lib/decompress_bunzip2.c:511: warning: the frame size of 1920 bytes is larger than 1024 bytes
>>      
>
>    
>>   	int dbufCount, nextSym, dbufSize, groupCount, selector,
>> -		i, j, k, t, runPos, symCount, symTotal, nSelectors,
>> -		byteCount[256];
>> -	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
>> +		i, j, k, t, runPos, symCount, symTotal, nSelectors;
>> +	static int byteCount[256];
>> +	unsigned char uc, *selectors;
>> +	static unsigned char symToByte[256], mtfSymbol[256];
>>   	unsigned int *dbuf, origPtr;
>>      
> Um...  Some details might be useful, starting with "why can't that function
> be called from several processes at once"...
>    

Al, to be honest, I'm not 100% if this is single-threaded or not :/.  I 
was hoping that by throwing the patch out I would get either an ACK or a 
NAK on it because of the single threaded issue.  It seems to me (and I 
admit I might be totally wrong) that the bunzip2 function is only called 
during early boot,

#ifdef PREBOOT
STATIC int INIT decompress(unsigned char *buf, int len,
                         int(*fill)(void*, unsigned int),
                         int(*flush)(void*, unsigned int),
                         unsigned char *outbuf,
                         int *pos,
                         void(*error_fn)(char *x))
{
         return bunzip2(buf, len - 4, fill, flush, outbuf, pos, error_fn);
}
#endif

... which (again, if the assumptions I'm making are correct) means that 
only one cpu will be active.

/me hopes someone will correct him if he's wrong and that's why hpa and 
phillip are cc'd directly

If it isn't single threaded, then you're right -- a PREBOOT malloc is 
the way to go.

P.
