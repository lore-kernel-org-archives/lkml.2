Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0DNFuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:50:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38762 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0DNFul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eNl3SvqZdiAa67aZ4hziksEFNGuLIKe5IXWfjw3L30x3RWKIfO2VzNz3xQwBT/E9Cg
         t6frd5/gJvb0rGGX0Bz4L7ro4Ai4FQJSBS1NoAbnQrgml7hdXcUqQlkRcrDmMGt1RLrP
         Hg7n7C+bKMUaAqlcimmcKJykb5fNP0o8YTZsg=
MIME-Version: 1.0
In-Reply-To: <j2z7e0fb38c1004132002sba54d278xc0337bed6e09dec5@mail.gmail.com>
References: <20100414024842.GB3718@localhost.localdomain>
	 <j2z7e0fb38c1004132002sba54d278xc0337bed6e09dec5@mail.gmail.com>
Date: Wed, 14 Apr 2010 13:50:40 +0800
Message-ID: <v2l628d1651004132250nf7df1f63y2494df724adda489@mail.gmail.com>
Subject: Re: Security: Replace dac_mmap_min_addr to mmap_min_addr in 
	cap_file_mmap()
From: wzt wzt <wzt.wzt@gmail.com>
To: Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

still not understand,  if CONFIG_LSM_MMAP_MIN_ADDR is not set,
mmap_min_addr is equal dac_mmap_min_addr, right?
if not, mmap_min_addr is set as CONFIG_LSM_MMAP_MIN_ADDR.  what's the
effect of mmap_min_addr?  except round_hint_to_min() will use
mmap_min_addr, any other functions will call it?
Anyway, the comments need change mmap_min_addr as dac_mmap_min_addr,
right? If i'm wrong, please point it, thanks.
/*
 * If the process is attempting to map memory below mmap_min_addr they need   |{
 * CAP_SYS_RAWIO.
 */

On Wed, Apr 14, 2010 at 11:02 AM, Eric Paris <eparis@parisplace.org> wrote:
> NAK NAK NAK
>
> go back and reread the whole purpose for the separation.
>
> -Eric
>
> On Tue, Apr 13, 2010 at 10:48 PM,  <wzt.wzt@gmail.com> wrote:
>> cap_file_mmap() comments said "If the process is attempting to map
>> memory below mmap_min_addr", if CONFIG_LSM_MMAP_MIN_ADDR is set,
>> dac_mmap_min_addr is not equal mmap_min_addr, so replace dac_mmap_min_addr
>> to mmap_min_addr seems to be better.
>>
>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>>
>> ---
>>  include/linux/security.h |    1 +
>>  security/commoncap.c     |    2 +-
>>  2 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 233d20b..61fd9e7 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -101,6 +101,7 @@ void reset_security_ops(void);
>>  extern unsigned long mmap_min_addr;
>>  extern unsigned long dac_mmap_min_addr;
>>  #else
>> +#define mmap_min_addr          0UL
>>  #define dac_mmap_min_addr      0UL
>>  #endif
>>
>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index 6166973..878cf89 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -942,7 +942,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
>>  {
>>        int ret = 0;
>>
>> -       if (addr < dac_mmap_min_addr) {
>> +       if (addr < mmap_min_addr) {
>>                ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
>>                                  SECURITY_CAP_AUDIT);
>>                /* set PF_SUPERPRIV if it turns out we allow the low mmap */
>> --
>> 1.6.5.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
