Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2AMXeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:34:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab2AMXeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:34:13 -0500
Message-ID: <1326497447.4342.31.camel@localhost>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Eric Paris <eparis@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, djm@mindrot.org, torvalds@linux-foundation.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Fri, 13 Jan 2012 18:30:47 -0500
In-Reply-To: <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
	 <20120112162231.GA23960@redhat.com>
	 <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	 <20120112172315.GA26295@redhat.com>
	 <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
	 <20120113173153.GA24273@redhat.com>
	 <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
	 <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-30ghNdsomXU63IqDDUZn"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-30ghNdsomXU63IqDDUZn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

For anyone who is interested I hacked up a program to turn what I think
is a readable seccomp syntax into BPF rules.  It should make it easier
to prototype this new thing.  The translator needs a LOT of love to be
worth much, but for now it can handle a couple of things and can build a
set of rules!

The rules are of the form:
label object:
	value label

So using Will's BPF example code in my syntax looks like:

start syscall:
        rt_sigreturn success
        sigreturn success
        exit_group success
        exit success
        read read
        write write
read arg0:
        0 success
write arg0:
        1 success
        2 success

So this says the first label is "start" and it is going to deal with the
syscall number.  The first value is 'rt_sigreturn' and if syscall ==
rt_sigreturn will cause you to jump to 'success' (success and fail are
implied labels).  If the syscall is 'write' we will jump to 'write.'
The write rules look at arg0.  If arg0 == "1" we jump to "success".  If
you run that syntax through my translator you should get Will's BPF
rules!

You'll quickly notice that the translator only understands "syscall" and
"arg0" and only x86_32, but it should be easy to add more, support the
right registers on different arches, etc, etc.  If others think they
might want to hack on the translator I put it at:

http://git.infradead.org/users/eparis/bpf-translate.git

-Eric

--=-30ghNdsomXU63IqDDUZn
Content-Disposition: attachment; filename="translate.py"
Content-Type: text/x-python; name="translate.py"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#! /usr/bin/python -Es

import sys

if len(sys.argv) > 1:
	file = open(sys.argv[1])
else:
	file = sys.stdin

linecount = 0
sections = []
rules = {}
output = []
section_map = {}

def new_section(section):
	if section[1] == "syscall":
		output.append(("BPF_STMT(BPF_LD+BPF_W+BPF_IND, regoffset(orig_eax)),", section[0]))
	elif section[1] == "arg0":
		output.append(("BPF_STMT(BPF_LD+BPF_W+BPF_IND, regoffset(ebx)),", section[0]))
	elif section[0] == "success":
		output.append(("BPF_STMT(BPF_LD+BPF_W+BPF_LEN, 0),", section[0]))
	elif section[0] == "fail":
		output.append(("BPF_STMT(BPF_RET+BPF_A,0),", section[0]))

def new_rule(rule, section, last=None):
	string = "BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, %s, %s, 0)," % (rule[0], rule[1])
	if last:
		string = string.replace(", 0)", ", fail)")
	output.append((string, "0"))

if __name__ == '__main__':
	while 1:
		line = file.readline()
		if not line:
			break
		linecount = linecount + 1
		if ":" in line:
			sections.append(line.strip().strip(":").split())
		else:
			key = sections[-1][0]
			current_list = rules.get(key, [])
			newrule = line.strip().split()
			if sections[-1][1] == "syscall":
				newrule = ["__NR_%s" % newrule[0], newrule[1]]
			current_list.append(newrule)
			rules[key] = current_list
			
		

sections.append(["success", "*"])
sections.append(["fail", "*"])

for section in sections:
	new_section(section)
	if rules.has_key(section[0]):
		for rule in rules[section[0]]:
			if rule == rules[section[0]][-1]:
				new_rule(rule, section, 1)
			else:
				new_rule(rule, section)

for lineno,line in enumerate(output):
	if (line[1] == "0"):
		continue
	section_map[line[1]] = lineno

for lineno,line in enumerate(output):
	line = line[0]
	for section in section_map.keys():
		# Only replace in those last 2 commas 
		#if VALUE == section:
			#replace VALUE with str(section_map[section] - lineno - 2)
		splitline = line.split(",")
		if section in splitline[-3]:
			splitline[-3] = splitline[-3].replace(section, str(section_map[section] - lineno - 1))
		if section in splitline[-2]:
			splitline[-2] = splitline[-2].replace(section, str(section_map[section] - lineno - 1))
		line = ",".join(splitline)
	print line

--=-30ghNdsomXU63IqDDUZn--

