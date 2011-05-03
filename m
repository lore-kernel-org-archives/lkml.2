Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1ECXOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53935 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab1ECXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:47 -0400
Message-Id: <20110503231023.968960757@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC patch 00/32] TRACE_EVENT: cleanup for code-size reduction (v2)
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I implemented the TRACE_EVENT macros as arrays of fields and arrays of
events in LTTng, and realised that it could benefit Ftrace too by
cutting down its code size. As I know that code size footprint is an
issue Steven has been wanting to tackle for a while, I am sending this
"semicolon removal" patchset, which is a prerequisite to be able to
generate arrays of events.

* Changelog since v1
  - Removed all ifdefs around declarations (it is now _only_ a semicolon
    removal patchset).

The main difference between the approaches Ftrace and LTTng have taken
is that Ftrace creates a "ftrace_define_fields_##call" function for each
event which calls trace_define_field for each field of each event. In
LTTng, I did the following (code snippet from [1]):

struct lttng_event_field {
        const char *name;
        const struct lttng_type type;
};
struct lttng_event_desc {
        const struct lttng_event_field *fields;
        const char *name;
        unsigned int nr_fields;
};
#undef DEFINE_EVENT
#define DEFINE_EVENT(_template, _name, _proto, _args)                          \
                {                                                              \
                        .fields = __event_fields___##_template,                \
                        .name = #_name,                                        \
                        .nr_fields = ARRAY_SIZE(__event_fields___##_template), \
                },
#define TP_ID1(_token, _system) _token##_system
#define TP_ID(_token, _system)  TP_ID1(_token, _system)

static const struct lttng_event_desc TP_ID(__event_desc___, TRACE_SYSTEM)[] = {
#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
};
And for creation of __event_fields___##_template, which allows to keep
all fields in another array (which should be defined in a phase prior to
the event array definition), I did:

#undef __field
#define __field(_type, _item)                                   \
        { .name = #_item, .type = { .atype = atype_integer, .name = #_type} },
(similar for __field_ext, __array, __dynamic_array, __string)

#undef TP_STRUCT__entry
#define TP_STRUCT__entry(args...) args  /* Only one used in this phase */
#undef DECLARE_EVENT_CLASS
#define DECLARE_EVENT_CLASS(_name, _proto, _args, _tstruct, _assign, _print) \
        static const struct lttng_event_field __event_fields___##_name[] = { \
                _tstruct \
        };
For the declaration of struct lttng_type, which contains the field type
information in a union, see [2].

Best regards,

Mathieu

[1] http://git.lttng.org/?p=lttng-modules.git;a=blob;f=probes/lttng-events.h;h=a05c29d56771b89807ffef035b7cd6df34a0b97f;hb=HEAD
[2] http://git.lttng.org/?p=lttng-modules.git;a=blob;f=probes/lttng-types.h;h=0192bffaf2f321f446f71a13901e2ab09fd69663;hb=HEAD

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
