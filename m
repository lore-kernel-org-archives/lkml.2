Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3AJQLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:11:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:47403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3AJQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:11:22 -0500
Message-ID: <50EEE868.70705@infradead.org>
Date: Thu, 10 Jan 2013 08:12:24 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>
Subject: Re: [PATCH] Fix wrong EOF compare
References: <1357797904-11194-1-git-send-email-minchan@kernel.org> <xa1ta9shm531.fsf@mina86.com>
In-Reply-To: <xa1ta9shm531.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/13 07:26, Michal Nazarewicz wrote:
> On Thu, Jan 10 2013, Minchan Kim <minchan@kernel.org> wrote:
>> getc returns "int" so EOF could be -1 but storing getc's return
>> value to char directly makes the vaule to 255 so below condition
>> is always false.
> 
> Technically, this is implementation defined and I believe on many
> systems char is signed thus the loop will end on EOF or byte 255.
> 
> Either way, my point is the patch is correct, but the comment is not. ;)

and change spelling of 'vaule' to 'value'
and test build it please.

> 
> Of course, even better if the function just used fgets(), ie. something
> like:
> 
> int read_block(char *buf, int buf_size, FILE *fin)
> {
> 	char *curr = buf, *const buf_end = buf + buf_size;
> 
> 	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
> 		if (*curr == '\n') /* empty line */
> 			return curr - buf;
> 		curr += strlen(curr);
> 	}
> 
> 	return -1; /* EOF or no space left in buf. */
> }
> 
> which is much shorter and does not have buffer overflow issues.
> 
>> It happens in my ARM system so loop is not ended, then segfaulted.
>> This patch fixes it.
>>
>>                 *curr = getc(fin); // *curr = 255
>>                 if (*curr == EOF) return -1; // if ( 255 == -1)
>>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Andy Whitcroft <apw@shadowen.org>
>> Cc: Alexander Nyberg <alexn@dsv.su.se>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  Documentation/page_owner.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
>> index f0156e1..b777fb6 100644
>> --- a/Documentation/page_owner.c
>> +++ b/Documentation/page_owner.c
>> @@ -32,12 +32,14 @@ int read_block(char *buf, FILE *fin)
>>  {
>>  	int ret = 0;
>>  	int hit = 0;
>> +	int vaule;
>>  	char *curr = buf;
>>  
>>  	for (;;) {
>> -		*curr = getc(fin);
>> -		if (*curr == EOF) return -1;
>> +		value = getc(fin);
>> +		if (value == EOF) return -1;
>>  
>> +		*curr = value;
>>  		ret++;
>>  		if (*curr == '\n' && hit == 1)
>>  			return ret - 1;
> 
> 
> 


-- 
~Randy
