Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0LVE5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 23:57:51 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34869 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0LVE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 23:57:50 -0500
X-AuditID: b753bd60-a55a3ba000003e7d-58-4d11854b888b
Message-ID: <4D118543.3040007@hitachi.com>
Date: Wed, 22 Dec 2010 13:57:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip 2/4] [BUGFIX]perf: Fix strlist__parse_list to	handle
 const string
References: <20101217131149.24123.96128.stgit@ltc236.sdl.hitachi.co.jp> <20101217131206.24123.87394.stgit@ltc236.sdl.hitachi.co.jp> <20101221182321.GA15683@ghostprotocols.net>
In-Reply-To: <20101221182321.GA15683@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/22 3:23), Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 17, 2010 at 10:12:06PM +0900, Masami Hiramatsu escreveu:
>> Fix strlist__parse_list to handle const string. Without this patch,
>> strlist__parse_list() causes SEGV when caller passes a constant
>> string.
>  
>> +++ b/tools/perf/util/strlist.c
>> @@ -136,13 +136,19 @@ static int strlist__parse_list_entry(struct strlist *self, const char *s)
>>  
>>  int strlist__parse_list(struct strlist *self, const char *s)
>>  {
>> -	char *sep;
>> +	char *sep, *tmp;
>>  	int err;
>>  
>> +	/* This method requires strdup, because this changes given string */
>> +	if (!self->dupstr)
>> +		return -EINVAL;
>> +
> 
> Why is the above check needed if you solved the problem by strnduping at
> each separator?

Without dupstr, strlist(str_node__delete) will not release
allocated buffer... And we have to release it if the parsed
string started with "file://" after loading file.

(Ah, and there is a same problem in strlist__load() too...)

> Wouldn't be better to just stop changing the string by passing the
> length to strlist__parse_list_entry, etc?

Yeah, it could be, but in that case, we need changing code
wider.
I think this is the simplest solution. :)

(Of course, we have to check dupstr flag on top of strlist__load too.)

Thank you,

>>  	while ((sep = strchr(s, ',')) != NULL) {
>> -		*sep = '\0';
>> -		err = strlist__parse_list_entry(self, s);
>> -		*sep = ',';
>> +		tmp = strndup(s, sep - s);
>> +		if (tmp == NULL)
>> +			return -ENOMEM;
>> +		err = strlist__parse_list_entry(self, tmp);
>> +		free(tmp);
>>  		if (err != 0)
>>  			return err;
>>  		s = sep + 1;

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
