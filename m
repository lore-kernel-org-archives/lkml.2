Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1FBNk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:40:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54275 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1FBNkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:40:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <1306934105-6280-1-git-send-email-lucas.demarchi@profusion.mobi>
	<alpine.LNX.2.00.1106011521160.12980@swampdragon.chaosbits.net>
	<BANLkTimnn8hAw7VqgbTTgheREox5DJBhcQ@mail.gmail.com>
Date: Thu, 02 Jun 2011 06:40:13 -0700
In-Reply-To: <BANLkTimnn8hAw7VqgbTTgheREox5DJBhcQ@mail.gmail.com> (Lucas De
	Marchi's message of "Wed, 1 Jun 2011 11:11:36 -0300")
Message-ID: <m1y61kfj2a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WITnPT6LWNxmPt7RHUED8m4AMKeDSj/8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: remove impossible condition check
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> [ CC'ing Al Viro ]
>
> On Wed, Jun 1, 2011 at 10:25 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>> How about compacting it even further by getting rid of the 'len' variable
>> as well?
>> Like this:
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> ---
>>  proc_sysctl.c |   10 ++--------
>>  1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
>> index f50133c..bd7f7af 100644
>> --- a/fs/proc/proc_sysctl.c
>> +++ b/fs/proc/proc_sysctl.c
>> @@ -49,17 +49,11 @@ out:
>>
>>  static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
>>  {
>> -       int len;
>>        for ( ; p->procname; p++) {
>> -
>> -               if (!p->procname)
>> -                       continue;
>> -
>> -               len = strlen(p->procname);
>> -               if (len != name->len)
>> +               if (strlen(p->procname) != name->len)
>>                        continue;
>>
>> -               if (memcmp(p->procname, name->name, len) != 0)
>> +               if (memcmp(p->procname, name->name, name->len) != 0)
>>                        continue;
>>
>>                /* I have a match */
>>
>
>
> Looking again at the code, I'm wondering if this is not actually a
> bug. There might be entries with procname == NULL, meaning they are
> not mirrored in /proc. What seems wrong is the condition in the for().
> It should stop when all fields are 0 (meaning the end of the table)
> instead of stopping when procname is NULL.

It is not a bug.  The condition was originally p->ctlname then
it became p->ctlname || p->procname and then finally I was able to
kill ctl_name.

What you see is a left over that didn't get removed.

This is also the second time in the last couple of weeks someone has
sent this patch. 

There is some ongoing work to make sysctl scale better that with
any luck should be ready for 3.1.  Decide which version of this
patch you like and please resend, and I will add this to my
sysctl tree.

Thank you,
Eric
