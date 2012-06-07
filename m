Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228Ab2FGRei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:34:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60068 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab2FGReh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120607164034.GQ9472@phenom.dumpdata.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
	<20120607164034.GQ9472@phenom.dumpdata.com>
Date: Thu, 7 Jun 2012 13:34:35 -0400
X-Google-Sender-Auth: cZTbZVxs9dCqppUOdvq4J4z6INs
Message-ID: <CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with kdb/kgdb
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:40 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Jun 07, 2012 at 09:30:06AM -0400, Ben Guthro wrote:
>> Fix the polling section of the hvc driver to use the global "last_hvc"
>> variable, rather than the ttys.
>
> Could you just do:
>
>       struct tty_struct *tty = driver->ttys[last_hvc];
>
> as well?

No. I tried this, and never got to the kdb prompt.
It seems that the problem is that you need to use the cons_ops variable

My efforts to fully understand the inner-workings of the console code
were thwarted by time. Its a twisty bunch of code.
If I used the cons_ops variable static to the module, it was OK.
If I used driver->ttys - {get,put}_chars() never got called.


> So how come the '0' one did not work? Is that b/c
> of console=tty becoming '0' instead of hvc0? Is there a crash
> involved with this? Or is that it just is listening on the
> wrong console (and which one is that?)

See above.

>>
>> With this change debugging a xen dom0 kernel is possible via the
>> following kernel parameter:
>> kgdboc=hvc0
>
> Hm, if that is the problem then this should also be a problem on
> IBM Power boxes I would think?

Not sure...but I think the original submitter of this code was

commit 762e77ae7dd055d0b77e0ad34d87db7416df109e
Author: Anton Blanchard <anton@samba.org>
Date:   Tue Jul 12 19:44:05 2011 +0000

    hvc_console: Add kdb support


Was that for IBM?

>
>>
>> Signed-off-by: Ben Guthro <Benjamin.Guthro@citrix.com>
>>
>>
>> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
>> index 2d691eb..3750e74 100644
>> --- a/drivers/tty/hvc/hvc_console.c
>> +++ b/drivers/tty/hvc/hvc_console.c
>> @@ -766,12 +766,10 @@ int hvc_poll_init(struct tty_driver *driver, int
>> line, char *options)
>>
>>  static int hvc_poll_get_char(struct tty_driver *driver, int line)
>>  {
>> -       struct tty_struct *tty = driver->ttys[0];
>> -       struct hvc_struct *hp = tty->driver_data;
>>         int n;
>>         char ch;
>>
>> -       n = hp->ops->get_chars(hp->vtermno, &ch, 1);
>> +       n = cons_ops[last_hvc]->get_chars(vtermnos[last_hvc], &ch, 1);
>>
>>         if (n == 0)
>>                 return NO_POLL_CHAR;
>> @@ -781,12 +779,10 @@ static int hvc_poll_get_char(struct tty_driver
>> *driver, int line)
>>
>>  static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
>>  {
>> -       struct tty_struct *tty = driver->ttys[0];
>> -       struct hvc_struct *hp = tty->driver_data;
>>         int n;
>>
>>         do {
>> -               n = hp->ops->put_chars(hp->vtermno, &ch, 1);
>> +               n = cons_ops[last_hvc]->put_chars(vtermnos[last_hvc], &ch, 1);
>>         } while (n <= 0);
>>  }
>>  #endif
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org
>> http://lists.xen.org/xen-devel
