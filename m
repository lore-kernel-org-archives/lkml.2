Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab0EDRJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:09:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51216 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932206Ab0EDRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:09:10 -0400
Date: Tue, 4 May 2010 18:14:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       <yong.y.wang@intel.com>, <qi.wang@intel.com>, <joel.clark@intel.com>,
       <andrew.chih.howe.khor@intel.com>
Subject: Re: [PATCH] Topcliff UART: Add the UART driver [2/2]
Message-ID: <20100504181448.04d24eee@lxorguk.ukuu.org.uk>
In-Reply-To: <001601cae67e$2b6900d0$66f8800a@maildom.okisemi.com>
References: <001f01cae5f9$157be920$66f8800a@maildom.okisemi.com>
	<20100427.093307.212682271.davem@davemloft.net>
	<001601cae67e$2b6900d0$66f8800a@maildom.okisemi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 11:54:43 +0900
"Masayuki Ohtake" <masa-korg@dsn.okisemi.com> wrote:

> Hi David Miller
> 
> Thank you for you reporting.
> We will resubmit our patches with plain, unformatted, ASCII text.

I got annoyed enough by the strange commenting to write the following -
which will make a good first pass at turning the existing comments into
kernel-doc style. It's a quick hack - check the output against the input ;)

-------

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

/* Topwhack - a quick hack to whack the topcliffe headers into kernel-doc style
   formats */

static fpos_t mark;
static int mark_line;
static int line;

static char *read_line(FILE *in)
{
  static char buf[2048];
  char *p;
  if (fgets(buf, 2048, in) == NULL)
    return NULL;
  line++;
  p = strchr(buf, '\n');
  if (p == NULL) {
    fprintf(stderr, "Line %d is too long.\n", line);
    exit(1);
  }
  *p = 0;
/*  printf("%d: %s\n", line, buf); */
  return buf;
}

static void make_mark(FILE *in)
{
  mark_line = line;
  if (fgetpos(in, &mark) == -1) {
    perror("fgetpos");
    exit(1);
  }
}

static void from_mark(FILE *in)
{
  line = mark_line;
  if (fsetpos(in, &mark) == -1) {
    perror("fsetpos");
    exit(1);
  }
}

static char *find_tag(FILE *in, char *tag, int n)
{
  char *p;
  char *at;
  int len = strlen(tag);
  
  if (n == 1)
    from_mark(in);

  do {
    p = read_line(in);
    if (p == NULL)
      return NULL;
    if (strstr(p, "*/"))
      return NULL;
    at = strchr(p, '@');
    if (at == NULL)
      continue;
    if (strncmp(at + 1, tag, len) || !isspace(at[len + 1]))
      continue;
    at = at + len + 1;
    while(isspace(*at))
      at++;
    return at;
  }
  while(1);
}

static char *extract_tag(FILE *in, char *tag, int n)
{
  int taglen;
  int tagpos;
  char *tbuf;
  int l;
  char *p = find_tag(in, tag, n);
  if (p == NULL)
    return NULL;
  
  tagpos = strlen(p);
  
  if (tagpos > 4096)
    taglen = tagpos * 2;
  else
    taglen = 4096;
    
  tbuf = malloc(taglen);
  if (tbuf == NULL) {
    fprintf(stderr, "Out of memory.\n");
    exit(1);
  }
  
  memcpy(tbuf, p, tagpos);
  
  do {
    p = read_line(in);
    if (p == NULL)
      break;
    while(isspace(*p))
      p++;
    if (*p == '@' && strncmp(p, "@ref", 4) != 0)
      break;
    if (strncmp(p, "*/", 2) == 0)
      break;
    l = strlen(p);
    if (tagpos + l + 1 >= taglen) {
      taglen += 8192;
      tbuf = realloc(tbuf, taglen);
      if (tbuf == NULL) {
        fprintf(stderr, "Out of memory.\n");
        exit(1);
      }
    }
    tbuf[tagpos++] = ' ';
    memcpy(tbuf + tagpos, p, l);
    tagpos += l;
  }
  while(1);
  tbuf[tagpos] = 0;
  return tbuf;
}

static void free_tag(char *p)
{
  if (p)
    free(p);
}

static char *func_name(char *p)
{
  char *e = strchr(p, '(');
  if (e == NULL)
    return "*INVALID*";
  *e = 0;
  while(--e >= p && isspace(*e))
    continue;
  while(--e >= p && !isspace(*e))
    continue;
  if (!isspace(*e))
    return "*INVALID*";
  return e + 1;
}

static char *zap_stop(char *p)
{
  int e = strlen(p);
  while (e && isspace(p[e - 1]))
    e--;
  if (e && p[e-1] ==  '.')
    p[e-1] = 0;
  p[e] = 0;
  return p;
}
    
static void format_parameter(char *p)
{
  while(isspace(*p))
    p++;
  printf(" *\t@");
  while(!isspace(*p)) {
    putchar(*p);
    p++;
  }
retry:
  while(isspace(*p))
    p++;
  if (*p == '[') {
    p = strchr(p, ']');
    if (p == NULL) {
      fprintf(stderr, "Formatting error at %d\n", line);
      exit(1);
    }
    p++;
    goto retry;
  }
  printf(": %s\n", zap_stop(p));
}


static void print_tidy(char *p, char *hp)
{
  int pos = 0;
  char *wp;
  
  if (hp) {
    printf(" *\t%s ", hp);
    pos = strlen(hp) + 1;
  } else
    printf(" *\t");

  while(*p) {
    while(isspace(*p))
      p++;
    wp = p;
    while(*p && !isspace(*p))
      p++;
    if (p - wp == 4 && memcmp(wp, "@ref", 4) == 0)
      continue;
    if (p - wp + pos > 68) {
      pos = p - wp;
      printf("\n *\t");
    } else {
      if (pos)
        printf(" ");
      pos += p - wp + 1;
    }
    if (*p)
      *p++ = 0;
    printf("%s", wp);
  }
  printf("\n");
}
   
static void format_header(FILE *in)
{
  char *fn = extract_tag(in, "fn", 1);
  char *brief = extract_tag(in, "brief", 1);
  char *remarks = extract_tag(in, "remarks", 1);
  char *ret = extract_tag(in, "return", 1);
  char *see = extract_tag(in, "see", 1);
  char *var = extract_tag(in, "var", 1);
  char *def = extract_tag(in, "def", 1);
  char *param;
  
  if (def != NULL) {
    if (brief && !remarks) printf("/* %s */\n", zap_stop(brief));
    if (remarks) {
      printf("/*\n");
      if (brief)
        printf(" *\t%s\n", zap_stop(brief));
      print_tidy(remarks, NULL);
      printf(" */\n");
    }
  } else if (var != NULL) {
    if (brief && !remarks) printf("/* %s */\n", zap_stop(brief));
    if (remarks) {
      printf("/*\n");
      if (brief)
        printf(" *\t%s\n", zap_stop(brief));
      print_tidy(remarks, NULL);
      printf(" */\n");
    }
  } else if (fn != NULL) {
    printf("/**\n *\t%s - %s\n", func_name(fn), zap_stop(brief));
    from_mark(in);
    while((param = extract_tag(in, "param", 0)) != NULL) {
      format_parameter(param);
      free_tag(param);
    }
    printf(" *\n");
    if (remarks)
      print_tidy(remarks, NULL);
    if (ret)
      print_tidy(ret, "Returns:");
    if (see)
      printf(see, "See also:", see);
    printf(" */\n");
  }
  free_tag(fn);
  free_tag(brief);
  free_tag(remarks);
  free_tag(ret);
  free_tag(see);
  free_tag(var);
  free_tag(def);
  /* Find the end */
  find_tag(in, "dummy", 1);
}


int main(int argc, char *argv[])
{
  char *r;
  while((r = read_line(stdin)) != NULL) {
    if (strncmp(r, "/*!", 3) == 0) {
      make_mark(stdin);
      format_header(stdin);
    } else {
      printf("%s\n", r);
    }
  }
  exit(0);
}
