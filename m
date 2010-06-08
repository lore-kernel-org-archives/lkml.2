Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0FHCOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:14:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60393 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0FHCOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ap9q1hvLvTzF4TB3/CiY6L9Sj6e5xvnPjH7NGJLKfTUe47fXojXnHwbN8F3WOlZyJP
         NyE8p2sNyxwhtB0ekDgWUHhb5wxYZcGsARgZuqXIlrKtUqoDuJ4wCrAzKDRvl1bhm26w
         CeocQpGaleuYAbQ+wvdDDlgvHvuTsPqXG1twQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
	<C4177A0B-9A74-40E6-9A58-64418034232C@sandeen.net>
	<AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com>
Date: Mon, 7 Jun 2010 20:14:06 -0600
Message-ID: <AANLkTik4BmOSZ9xqsMcMVN_fkB79ySGQVVK56i1xUmFt@mail.gmail.com>
Subject: Fwd: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Mon, Jun 7, 2010 at 8:13 PM
Subject: Re: EXT3 File System Corruption 2.6.34
To: Eric Sandeen <sandeen@sandeen.net>


Well, I will set this as default from now on.  Tell Evil Emperor Linus
to put the fucking thing back the way it was so default kernel builds
are not fucked up.

Jeff

here is the source to the xdump.c file.  may be useful in the future
to someone who needs a tool to dump files to post to the list.  Anyway
-- easier to use than that fucking hexedit program.

:-)

// Released under GPLv2 or whatever fucking version you like

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

unsigned char *dumpAsBytes(unsigned char *p, unsigned long size,
unsigned long base)
{
  register unsigned long i, r, total, count;
  register unsigned char *op = p;

  count = size / 16;

  printf("           0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");

  for (r=0; r < count; r++)
  {
     printf("%08X ", (p - op) + base);
     for (total = 0, i=0; i < 16; i++, total++)
     {
        printf(" %02X", (unsigned char) p[i]);
     }
     printf("  ");
     for (i=0; i < total; i++)
     {
        if (p[i] < 32 || p[i] > 126)
           printf(".");
        else printf("%c", p[i]);
     }
     printf("\n");

     p = (void *)((unsigned long) p + (unsigned long) total);
  }
  return p;

}

unsigned char *dumpAsLong(unsigned char *p, unsigned long size,
unsigned long base)
{
  register int i, r, count;
  register unsigned char *op = p;
  unsigned long *lp;

  count = size / 16;

  lp = (unsigned long *) p;

  for (r=0; r < count; r++)
  {
     printf("%08X ", (p - op) + base);
     for (i=0; i < (16 / 4); i++)
     {
        printf(" %08X", (unsigned long) lp[i]);
     }
     printf("  ");
     for (i=0; i < 16; i++)
     {
        if (p[i] < 32 || p[i] > 126) printf(".");
        else printf("%c", p[i]);
     }
     printf("\n");

     p = (void *)((unsigned long) p + (unsigned long) 16);
     lp = (unsigned long *) p;
  }
  return p;

}

int getch(void)
{
  return getc(stdin);
}

unsigned long pause(void)
{
  extern int getch(void);
  register unsigned long key;

  printf(" --- More --- ");
  key = getch();
  printf("%c              %c", '\r', '\r');
  if (key == 0x1B) // ESCAPE
     return 1;
  else
     return 0;

}
unsigned char buffer[512];


int main(int argc, char *argv[])
{
   unsigned long rc, total = 0, offset = 0;
   register int fp;

   if (argc < 2)
   {
      printf("USAGE:  dump <filename.ext> <offset>\n");
      return 1;
   }

   if (argc == 3)
      offset = atol(argv[2]);


   fp = open(argv[1], O_RDWR);
   if (fp < 0)
   {
      printf("error opening file [%s]\n", argv[1]);
      return 1;
   }

   rc = lseek(fp, offset, SEEK_SET);
   if (rc == -1)
   {
      printf("error seeking file offset %d\n", offset);
      return 1;
   }

   total = offset;
   while (rc = read(fp, buffer, 256))
   {
      dumpAsBytes(buffer, rc, total);
      total += rc;

      if (pause())
         break;
   }

   close(fp);
   return 0;
}
