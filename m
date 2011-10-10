Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1JJWmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:42:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48147 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1JJWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:42:08 -0400
Date: Mon, 10 Oct 2011 15:42:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] checkpatch: Add a --strict check for utf-8 in commit
 logs
Message-Id: <20111010154205.02c3bd3e.akpm@linux-foundation.org>
In-Reply-To: <1318285950.2149.24.camel@Joe-Laptop>
References: <1318226216-5317-1-git-send-email-olof@lixom.net>
	<1318266599.27825.12.camel@Joe-Laptop>
	<20111010151027.bc397b85.akpm@linux-foundation.org>
	<1318285950.2149.24.camel@Joe-Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 15:32:30 -0700
Joe Perches <joe@perches.com> wrote:

> Some find using utf-8 in commit logs inappropriate.
> 
> Some patch commit logs contain unintended utf-8 characters
> when doing things like copy/pasting compilation output.
> 
> Look for the start of any commit log by skipping initial
> lines that look like email headers and "From: " lines.
> 
> Stop looking for utf-8 at the first signature line.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
> I don't feel strongly that this patch should be applied,
> that's why it's a --strict check and not on by default,
> but Andrew Morton seems to want something like it...

Mainly because of the non-ascii single-quote chars which gcc emits in
its warning/error messages.  I use LANG=C to stop gcc from doing that,
and also have a proglet to undo this nonsense when I'm merging patches
(below) (I totally forget how it works).  But I see such things turning
up in the tree via other merge paths.



#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

static void dump(int *buf)
{
	if (buf[0] == 0xE2 && buf[1] == 0x80 && buf[2] == 0x98) {
		putchar('`');
		buf[0] = 0;
		buf[1] = 0;
		buf[2] = 0;
	} else if (buf[0] == 0xE2 && buf[1] == 0x80 && buf[2] == 0x99) {
		putchar('\'');
		buf[0] = 0;
		buf[1] = 0;
		buf[2] = 0;
	} else if (buf[0] == 0xa1) {
		putchar('`');
		goto move;
	} else if (buf[0] == 0xa2) {
		putchar('\'');
		goto move;
	} else {
		if (buf[0])
			putchar(buf[0]);
move:
		buf[0] = buf[1]; 
		buf[1] = buf[2];
		buf[2] = 0;
	}
}

static void doit(FILE *f)
{
	int buf[3] = {};
	int c;

	while ((c = fgetc(f)) != EOF) {
		dump(buf);
		buf[2] = c;
	}
	dump(buf);
	dump(buf);
	dump(buf);
}

int main(int argc, char *argv[])
{
	if (argc == 1) {
		doit(stdin);
	} else {
		int i;

		for (i = 1; i < argc; i++) {
			FILE *f = fopen(argv[i], "r");

			if (f == NULL) {
				fprintf(stderr, "%s: cannot open `%s': %s\n",
					argv[0], argv[1], strerror(errno));
				exit(1);
			}
			doit(f);
			fclose(f);
		}
	}
	exit(0);
}			

