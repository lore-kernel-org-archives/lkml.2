Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0LYRst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 12:48:49 -0500
Received: from mail.aknet.ru ([78.158.192.28]:44447 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab0LYRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 12:48:49 -0500
X-Greylist: delayed 84795 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Dec 2010 12:48:48 EST
Message-ID: <4D162DB6.1000808@aknet.ru>
Date: Sat, 25 Dec 2010 20:45:26 +0300
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][patch] PR_DETACH: detach from parent
Content-Type: multipart/mixed;
 boundary="------------050802030201040309050401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050802030201040309050401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

I was trying to use daemon() library call to daemonize the process, and 
found out that it is not suitable
for the process that have threads: all the threads are simply being killed.
The reason is that the daemon() function does fork(), then exit() in 
parent and setsid() in child, which is
a bit ugly, and doesn't work with threads (fork() doesn't fork threads).
I've found no solution to that, and just hacked up one instead.
The attached patch adds the PR_DETACH prctl command, which detaches the 
process from its parent.
With that, the daemon() function can be implemented without the 
fork/exit/setsid hacks, and here is an
example of it:

---
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/prctl.h>

#ifndef PR_DETACH
#define PR_DETACH 35
#endif

int daemon2(int nochdir, int noclose)
{
      int err, fd;

      err = prctl(PR_DETACH);
      if (err == -1) {
          if (errno == EINVAL)
              errno = ENOTSUP;
          return -1;
      }

      fd = open("/dev/tty", O_RDWR);
      if (fd != -1) {
          ioctl(fd, TIOCNOTTY, NULL);
          close(fd);
      }

      if (!nochdir && chdir("/") == -1)
          return -1;

      if (!noclose) {
          fd = open("/dev/null", O_RDWR, 0);
          if (fd == -1)
              return -1;
          if (dup2(fd, STDIN_FILENO) == -1)
              return -1;
          if (dup2(fd, STDOUT_FILENO) == -1)
              return -1;
          if (dup2(fd, STDERR_FILENO) == -1)
              return -1;
          if (fd > 2)
              close(fd);
      }
      return 0;
}
---

With this implementation, all threads survive the daemonization.
Thoughts?


--------------050802030201040309050401
Content-Type: text/plain;
 name="pr_detach.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="pr_detach.diff"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcHJjdGwuaCBiL2luY2x1ZGUvbGludXgvcHJj
dGwuaAppbmRleCBhM2JhZWIyLi5mYmQyNDUxIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L3ByY3RsLmgKKysrIGIvaW5jbHVkZS9saW51eC9wcmN0bC5oCkBAIC0xMDIsNCArMTAyLDYg
QEAKIAogI2RlZmluZSBQUl9NQ0VfS0lMTF9HRVQgMzQKIAorI2RlZmluZSBQUl9ERVRBQ0gg
MzUKKwogI2VuZGlmIC8qIF9MSU5VWF9QUkNUTF9IICovCmRpZmYgLS1naXQgYS9rZXJuZWwv
c2lnbmFsLmMgYi9rZXJuZWwvc2lnbmFsLmMKaW5kZXggNGUzY2ZmMS4uMmNkNDk1YSAxMDA2
NDQKLS0tIGEva2VybmVsL3NpZ25hbC5jCisrKyBiL2tlcm5lbC9zaWduYWwuYwpAQCAtMTQ1
MCwxMCArMTQ1MCwxMCBAQCBpbnQgZG9fbm90aWZ5X3BhcmVudChzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRzaywgaW50IHNpZykKIAogCUJVR19PTihzaWcgPT0gLTEpOwogCi0gCS8qIGRvX25v
dGlmeV9wYXJlbnRfY2xkc3RvcCBzaG91bGQgaGF2ZSBiZWVuIGNhbGxlZCBpbnN0ZWFkLiAg
Ki8KLSAJQlVHX09OKHRhc2tfaXNfc3RvcHBlZF9vcl90cmFjZWQodHNrKSk7CisJLyogZG9f
bm90aWZ5X3BhcmVudF9jbGRzdG9wIHNob3VsZCBoYXZlIGJlZW4gY2FsbGVkIGluc3RlYWQu
ICAqLworCUJVR19PTih0YXNrX2lzX3N0b3BwZWRfb3JfdHJhY2VkKHRzaykpOwogCi0JQlVH
X09OKCF0YXNrX3B0cmFjZSh0c2spICYmCisJQlVHX09OKCF0YXNrX3B0cmFjZSh0c2spICYm
ICh0c2stPmZsYWdzICYgUEZfRVhJVElORykgJiYKIAkgICAgICAgKHRzay0+Z3JvdXBfbGVh
ZGVyICE9IHRzayB8fCAhdGhyZWFkX2dyb3VwX2VtcHR5KHRzaykpKTsKIAogCWluZm8uc2lf
c2lnbm8gPSBzaWc7CmRpZmYgLS1naXQgYS9rZXJuZWwvc3lzLmMgYi9rZXJuZWwvc3lzLmMK
aW5kZXggN2Y1YTBjZC4uZmExMDczMiAxMDA2NDQKLS0tIGEva2VybmVsL3N5cy5jCisrKyBi
L2tlcm5lbC9zeXMuYwpAQCAtMTcyNyw2ICsxNzI3LDIxIEBAIFNZU0NBTExfREVGSU5FNShw
cmN0bCwgaW50LCBvcHRpb24sIHVuc2lnbmVkIGxvbmcsIGFyZzIsIHVuc2lnbmVkIGxvbmcs
IGFyZzMsCiAJCQllbHNlCiAJCQkJZXJyb3IgPSBQUl9NQ0VfS0lMTF9ERUZBVUxUOwogCQkJ
YnJlYWs7CisJCWNhc2UgUFJfREVUQUNIOgorCQkJZXJyb3IgPSAtRVBFUk07CisJCQlpZiAo
bWUtPnJlYWxfcGFyZW50ID09IGluaXRfcGlkX25zLmNoaWxkX3JlYXBlcikKKwkJCQlicmVh
azsKKwkJCWlmIChtZS0+Z3JvdXBfbGVhZGVyICE9IG1lKQorCQkJCWJyZWFrOworCQkJZXhp
dF9wdHJhY2UobWUpOworCQkJZG9fbm90aWZ5X3BhcmVudChtZSwgbWUtPmV4aXRfc2lnbmFs
KTsKKwkJCW1lLT5leGl0X3NpZ25hbCA9IFNJR0NITEQ7CisJCQltZS0+cGFyZW50ID0gbWUt
PnJlYWxfcGFyZW50ID0KKwkJCQlpbml0X3BpZF9ucy5jaGlsZF9yZWFwZXI7CisJCQlsaXN0
X21vdmVfdGFpbCgmbWUtPnNpYmxpbmcsCisJCQkJJm1lLT5yZWFsX3BhcmVudC0+Y2hpbGRy
ZW4pOworCQkJZXJyb3IgPSAwOworCQkJYnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQllcnJvciA9
IC1FSU5WQUw7CiAJCQlicmVhazsK
--------------050802030201040309050401--
