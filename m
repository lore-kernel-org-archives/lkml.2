Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476Ab2LHSVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 13:21:53 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44763 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab2LHSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 13:21:52 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2012 13:21:51 EST
MIME-Version: 1.0
In-Reply-To: <1354988739.3198.3.camel@joe-AO722>
References: <1354988074-2165-1-git-send-email-peter.senna@gmail.com>
	<1354988739.3198.3.camel@joe-AO722>
Date: Sat, 8 Dec 2012 16:13:47 -0200
Message-ID: <CA+MoWDr0JT0T-0ZUDsqceuXKbjW_mavS9t6HGkFR4dz2XUygWg@mail.gmail.com>
Subject: Re: [PATCH] scripts/coccinelle/misc/semicolon.cocci: Add unneeded
 semicolon test
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: mmarek@suse.cz, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 3:45 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2012-12-08 at 15:34 -0200, Peter Senna Tschudin wrote:
>> This semantic patch looks for semicolons that can be removed without
>> changing the semantics of the code. The confidence is moderate
>> because there are some false positives on cases like:
>>
>> b/drivers/mmc/host/cb710-mmc.c:589
>>                 break;
>>         case MMC_POWER_UP:
>>         default:
>> -               /* ignore */;
>>         }
> []
>> diff --git a/scripts/coccinelle/misc/semicolon.cocci b/scripts/coccinelle/misc/semicolon.cocci
> []
>> +@r1@
>> +statement S;
>> +position p1;
>> +position p != {r_default.p, r_case.p};
>> +identifier label;
>> +@@
>> +(
>> +label:;
>> +|
>> +S@p1;@p
>> +)
>> +
>
> I believe this also fails on this case:
>
>         void some_func(...)
>         {
>                 ...
>                 if (foo)
>                         goto exit;
>                 ...
>
>         exit:
>                 ;
>         }
>
> where gcc needs a semicolon after a label before a function exit.

No it does not fail. This issue is switch/case specific. See how I've tested:

$ cat /tmp/test.c
void some_func(void){
        int *foo;
        if (foo)
        goto exit;

exit:
;
}

void few_func (void){
        int a;
        switch (a){
                case 1:
                        a=1;
                        break;
                case 2:
                default:
                        ;
        }
}

void main (void)
{
        int a;
        some_func();
        few_func();
}


$ spatch -D patch scripts/coccinelle/misc/semicolon.cocci /tmp/test.c
init_defs_builtins: /usr/local/share/coccinelle/standard.h
HANDLING: /tmp/test.c
diff =
--- /tmp/test.c
+++ /tmp/cocci-output-2570-defed8-test.c
@@ -15,7 +15,6 @@ void few_func (void){
  break;
  case 2:
  default:
- ;
  }
 }



>



--
Peter
